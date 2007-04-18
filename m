Return-Path: <linux-kernel-owner+w=401wt.eu-S1161461AbXDRI6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161461AbXDRI6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161464AbXDRI6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:58:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60829 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161461AbXDRI6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:58:13 -0400
Date: Wed, 18 Apr 2007 10:57:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418085752.GA16233@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704141809.58737.caglar@pardus.org.tr> <20070414160939.GB3099@elte.hu> <200704141959.50076.caglar@pardus.org.tr> <20070415161348.GA30625@elte.hu> <20070415162508.GA4526@elte.hu> <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <20070418082744.GA14009@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418082744.GA14009@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> update: i've reproduced one kind of a hang but i'm not sure it's the 
> same hang Ismail is seeing. It was quite hard to trigger it under CFS, 
> i had to do wild forward/backward button seeks on a real DVD and i 
> mixed it with CPU-intense workloads on the same box. Here are the 
> straces and gdb backtraces:

these were only the threads that showed up in htop. Here's a full 
analysis about what all threads are doing:

 Process 9303: stuck in xine_play()/pthread_mutex_lock()
 Process 9319:  stuck in pthread_cond_timedwait()
 Process 9320:  stuck in pthread_cond_timedwait()
 Process 9321: loop of ~3 msec nanosleeps
 Process 9322: loop of poll() calls every 335 msecs
 Process 9323:  stuck in pthread_cond_timedwait()
 Process 9324: stuck in a loop of 1-second futex-waits + mmap/munmap (malloc)
 Process 9325:  stuck in pthread_cond_timedwait()
 Process 9326:  stuck in pthread_cond_timedwait()
 Process 9327:  stuck in pthread_cond_timedwait()

now here's a weird thing: occasionally, when i strace one of the 
threads, i can get a single frame refreshed in the Kaffeine window - but 
the general picture does not change, the same 'stuck' state is still 
there.

most threads are sitting in:

 #0  0xffffe410 in __kernel_vsyscall ()
 #1  0x4a25134c in pthread_cond_timedwait@@GLIBC_2.3.2 ()   from /lib/libpthread.so.0
 #2  0xb79f9a05 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
 #3  0x4a24d2db in start_thread () from /lib/libpthread.so.0
 #4  0x4a05820e in clone () from /lib/libc.so.6

9324 is looping around this place, apparently in the opengl video output 
driver, but the backtrace is not always this one:

 (gdb) bt
 #0  0x49ff7257 in memset () from /lib/libc.so.6
 #1  0x49ff1877 in calloc () from /lib/libc.so.6
 #2  0xb7a224d6 in xine_xmalloc_aligned () from /usr/lib/libxine.so.1
 #3  0xb708c8f6 in QWidget::setUpdatesEnabled ()
    from /usr/lib/xine/plugins/1.1.5/xineplug_vo_out_opengl.so
 #4  0xb7a0525a in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
 #5  0xb78944e4 in QWidget::setUpdatesEnabled ()
    from /usr/lib/xine/plugins/1.1.5/post/xineplug_post_tvtime.so
 #6  0xb7895234 in QWidget::setUpdatesEnabled ()
    from /usr/lib/xine/plugins/1.1.5/post/xineplug_post_tvtime.so
 #7  0xad4e5439 in QWidget::setUpdatesEnabled ()
    from /usr/lib/xine/plugins/1.1.5/xineplug_decode_mpeg2.so
 #8  0xad4fa8e1 in QWidget::setUpdatesEnabled ()
    from /usr/lib/xine/plugins/1.1.5/xineplug_decode_mpeg2.so
 #9  0xb7a032d6 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
 #10 0x4a24d2db in start_thread () from /lib/libpthread.so.0
 #11 0x4a05820e in clone () from /lib/libc.so.6

9321 is sitting in:

(gdb) bt
 #0  0xffffe410 in __kernel_vsyscall ()
 #1  0x4a2544a6 in nanosleep () from /lib/libpthread.so.0
 #2  0xb7a222fa in xine_usec_sleep () from /usr/lib/libxine.so.1
 #3  0xb7a073bb in QWidget::setUpdatesEnabled () from  /usr/lib/libxine.so.1
 #4  0x4a24d2db in start_thread () from /lib/libpthread.so.0
 #5  0x4a05820e in clone () from /lib/libc.so.6

9322 is in poll():

(gdb) bt
 #0  0xffffe410 in __kernel_vsyscall ()
 #1  0x4a04e533 in poll () from /lib/libc.so.6
 #2  0xb12e1f75 in QWidget::setUpdatesEnabled () from /usr/lib/xine/plugins/1.1.5/xineplug_ao_out_alsa.so
 #3  0x4a24d2db in start_thread () from /lib/libpthread.so.0
 #4  0x4a05820e in clone () from /lib/libc.so.6

9303 is stuck in xine_play(), pthread_mutex_lock():

 #0  0xffffe410 in __kernel_vsyscall ()
 #1  0x4a2538ce in __lll_mutex_lock_wait () from /lib/libpthread.so.0
 #2  0x4a24f71c in _L_mutex_lock_79 () from /lib/libpthread.so.0
 #3  0x4a24f24d in pthread_mutex_lock () from /lib/libpthread.so.0
 #4  0xb79f64f9 in xine_play () from /usr/lib/libxine.so.1
 #5  0xb7a9b0fb in KXineWidget::slotSeekToPosition () from /usr/lib/kde3/libxinepart.so
 #6  0xb7a9b3bc in KXineWidget::wheelEvent () from /usr/lib/kde3/libxinepart.so
 #7  0x4b5f9150 in QWidget::event () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #8  0x4b55353b in QApplication::internalNotify () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #9  0x4b55526e in QApplication::notify ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #10 0x4a72065e in KApplication::notify () from /usr/lib/libkdecore.so.4
 #11 0x4b4dd5de in QETWidget::translateWheelEvent ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #12 0x4b4eb41d in QETWidget::translateMouseEvent ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #13 0x4b4e9766 in QApplication::x11ProcessEvent ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #14 0x4b4fb38b in QEventLoop::processEvents ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #15 0x4b56ce30 in QEventLoop::enterLoop ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #16 0x4b56cce6 in QEventLoop::exec () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #17 0x4b55317f in QApplication::exec () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
 #18 0x0806fc1a in QWidget::setUpdatesEnabled ()
 #19 0x49f9df10 in __libc_start_main () from /lib/libc.so.6
 #20 0x0806f7e1 in QWidget::setUpdatesEnabled ()

library versions:

 xine-lib-1.1.5-1.fc7
 xine-plugin-1.0-3.fc7
 glibc-headers-2.5.90-21
 glibc-common-2.5.90-21
 glibc-2.5.90-21
 glibc-devel-2.5.90-21
 gxine-0.5.11-3.fc7
 kaffeine-0.8.3-4.fc7
 xine-0.99.4-11.lvn7
 xine-lib-extras-1.1.5-1.fc7
 gxine-mozplugin-0.5.11-3.fc7

	Ingo
