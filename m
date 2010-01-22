Return-Path: <linux-kernel-owner+w=401wt.eu-S1750822Ab0AVIvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750822Ab0AVIvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 03:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493Ab0AVIvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 03:51:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0AVIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 03:51:38 -0500
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Luca Zini <luca.zini@gmail.com>, aagaande@gmail.com, rdelcueto@hotmail.com,
       mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
In-Reply-To: <1264144758.8074.22.camel@marge.simson.net>
References: <201001211258.23499.luca.zini@gmail.com>
	 <20100121215438.GK17684@ldl.fc.hp.com>
	 <1264144758.8074.22.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 09:51:12 +0100
Message-ID: <1264150272.4283.1361.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 08:19 +0100, Mike Galbraith wrote:
> > if I run a cpu intensive process with the lowest priority (19
> > from man nice) I obtain much better performance that with the
> > highest priority available (-20 from man nice).
> >
> > For example the same file is processed by lame in 8.7 seconds
> > at the lowest priority, and in 12 seconds at the highest
> > priority.  Before posting a bug I wold like to understand if
> > this is a problem related to the i7 mobile (my processor is a
> > i7 Q720).
> > 
> > As far as I tested on the same laptop series (dell studio 15),
> > with the same kernel this problem does not exists.
> 
> So you only see this on the i7.  That's odd.  Can you try 33-rc5?
> 
> Posting a reliable reproducer would be nice.  It'd also be nice to see
> what all is running when you see this, and where.

Using a sample from: http://lame.sourceforge.net/quality.php

My laptop does:


# time nice -n 19 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null
LAME 3.98.2 64bits (http://www.mp3dev.org/)
Using polyphase lowpass filter, transition band: 19383 Hz - 19916 Hz
Encoding youcantdothat.wav to <stdout>
Encoding as 44.1 kHz j-stereo MPEG-1 Layer III VBR(q=0)
    Frame          |  CPU time/estim | REAL time/estim | play/CPU |    ETA
  1147/1147  (100%)|    0:03/    0:03|    0:03/    0:03|   9.3341x|    0:00
 32 [   1] *
256 [1009] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
320 [ 137] %%%%%%%%%
----------------------------------------------------------------------------
   kbps        LR    MS  %     long switch short %
  263.4       99.1   0.9        90.5   5.5   4.0

real    0m3.273s
user    0m3.217s
sys     0m0.022s


# time nice -n 0 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null 
LAME 3.98.2 64bits (http://www.mp3dev.org/)
Using polyphase lowpass filter, transition band: 19383 Hz - 19916 Hz
Encoding youcantdothat.wav to <stdout>
Encoding as 44.1 kHz j-stereo MPEG-1 Layer III VBR(q=0)
    Frame          |  CPU time/estim | REAL time/estim | play/CPU |    ETA
  1147/1147  (100%)|    0:01/    0:01|    0:01/    0:01|   27.239x|    0:00
 32 [   1] *
256 [1009] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
320 [ 137] %%%%%%%%%
----------------------------------------------------------------------------
   kbps        LR    MS  %     long switch short %
  263.4       99.1   0.9        90.5   5.5   4.0

real    0m1.121s
user    0m1.102s
sys     0m0.013s


# time nice -n -20 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null
LAME 3.98.2 64bits (http://www.mp3dev.org/)
Using polyphase lowpass filter, transition band: 19383 Hz - 19916 Hz
Encoding youcantdothat.wav to <stdout>
Encoding as 44.1 kHz j-stereo MPEG-1 Layer III VBR(q=0)
    Frame          |  CPU time/estim | REAL time/estim | play/CPU |    ETA
  1147/1147  (100%)|    0:01/    0:01|    0:01/    0:01|   27.239x|    0:00
 32 [   1] *
256 [1009] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
320 [ 137] %%%%%%%%%
----------------------------------------------------------------------------
   kbps        LR    MS  %     long switch short %
  263.4       99.1   0.9        90.5   5.5   4.0

real    0m1.112s
user    0m1.093s
sys     0m0.018s



On a Nehalem class server machine it does:


# time nice -n 19 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null
LAME 3.98.2 64bits (http://www.mp3dev.org/)
Using polyphase lowpass filter, transition band: 19383 Hz - 19916 Hz
Encoding youcantdothat.wav to <stdout>
Encoding as 44.1 kHz j-stereo MPEG-1 Layer III VBR(q=0)
    Frame          |  CPU time/estim | REAL time/estim | play/CPU |    ETA
  1147/1147  (100%)|    0:00/    0:00|    0:00/    0:00|   32.926x|    0:00
 32 [   1] *
256 [1009] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
320 [ 137] %%%%%%%%%
----------------------------------------------------------------------------
   kbps        LR    MS  %     long switch short %
  263.4       99.1   0.9        90.5   5.5   4.0

real    0m0.932s
user    0m0.917s
sys     0m0.005s


# time nice -n 0 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null
LAME 3.98.2 64bits (http://www.mp3dev.org/)
Using polyphase lowpass filter, transition band: 19383 Hz - 19916 Hz
Encoding youcantdothat.wav to <stdout>
Encoding as 44.1 kHz j-stereo MPEG-1 Layer III VBR(q=0)
    Frame          |  CPU time/estim | REAL time/estim | play/CPU |    ETA
  1147/1147  (100%)|    0:00/    0:00|    0:00/    0:00|   32.568x|    0:00
 32 [   1] *
256 [1009] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
320 [ 137] %%%%%%%%%
----------------------------------------------------------------------------
   kbps        LR    MS  %     long switch short %
  263.4       99.1   0.9        90.5   5.5   4.0

real    0m0.927s
user    0m0.922s
sys     0m0.003s


# time nice -n -20 lame -b 256 -V0 -h youcantdothat.wav - > /dev/null
LAME 3.98.2 64bits (http://www.mp3dev.org/)
Using polyphase lowpass filter, transition band: 19383 Hz - 19916 Hz
Encoding youcantdothat.wav to <stdout>
Encoding as 44.1 kHz j-stereo MPEG-1 Layer III VBR(q=0)
    Frame          |  CPU time/estim | REAL time/estim | play/CPU |    ETA
  1147/1147  (100%)|    0:00/    0:00|    0:00/    0:00|   32.926x|    0:00
 32 [   1] *
256 [1009] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
320 [ 137] %%%%%%%%%
----------------------------------------------------------------------------
   kbps        LR    MS  %     long switch short %
  263.4       99.1   0.9        90.5   5.5   4.0

real    0m0.919s
user    0m0.914s
sys     0m0.005s


