Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbYBUAIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbYBUAIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYBUAIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:08:10 -0500
Received: from smtp.ono.com ([62.42.230.12]:5668 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751221AbYBUAIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:08:09 -0500
Date: Thu, 21 Feb 2008 01:07:58 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Questions on rtc drivers...
Message-ID: <20080221010758.0276b369@werewolf>
X-Mailer: Claws Mail 3.3.0cvs16 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

since some time ago I have noticed that mplayer can't use the RTC for
time accounting. Perhaps it is deprecated and should be migrated to
hrtimers, that is what every reference I found said, but the fact is
that nowadays it uses it.

I thought I was because a misbuild of my kernel, but now I have just
built a 2.6.24.2 with every rtc modular to test them (in my case,
just rtc, genrtc and rtc-cmos - I'm not aware of any other that can
work on my mobo, ICH5/i875P).

I use a trimmed down version of the test in Documentacion/rtc.txt.
Results vary:

genrtc fails
crw-r--r-- 1 root root 10, 135 Feb 21 00:53 /dev/rtc
Using /dev/rtc
RTC_IRQP_READ ioctl: Invalid argument

rtc works
crw-r--r-- 1 root root 10, 135 Feb 21 00:53 /dev/rtc
Using /dev/rtc
Initial PI rate: 1024Hz
   2 Hz: ..........
   4 Hz: ..........
   8 Hz: ..........
  16 Hz: ..........
  32 Hz: ..........
  64 Hz: ..........
Device or resource busy
and rtc-cmos behaves strangely. After modprobe, even when /dev/rtc*
are already present, I have to wait even 5 seconds to not have a 'Device or
resource busy' error on open(). And when it opens it just gets stuck
after the first dot:

Using /dev/rtc
Initial PI rate: 1024Hz
   2 Hz: .

The loop is

        for (i=0; i<10; i++)
        {
            res = read(rtc,&data,sizeof(unsigned long));
            if (res<0)
            {
                perror("read");
                exit(errno);
            }
            printf(".");
            fflush(stdout);
        }

They all give different info in /proc/driver/rtc and
/proc/sys/dev/rtc/max-user-freq:

genrtc
crw-r--r-- 1 root root 10, 135 Feb 21 01:03 /dev/rtc
rtc_time    : 00:03:25
rtc_date    : 2008-02-21
rtc_epoch   : 1900
alarm       : 00:00:00
DST_enable  : no
BCD     : yes
24hr        : yes
square_wave : no
alarm_IRQ   : no
update_IRQ  : no
periodic_IRQ    : no
periodic_freq   : 0
batt_status : okay
cat: /proc/sys/dev/rtc/max-user-freq: No such file or directory

rtc
crw-r--r-- 1 root root 10, 135 Feb 21 01:03 /dev/rtc
rtc_time    : 00:03:26
rtc_date    : 2008-02-21
rtc_epoch   : 1900
alarm       : **:00:10
DST_enable  : no
BCD     : yes
24hr        : yes
square_wave : no
alarm_IRQ   : no
update_IRQ  : no
periodic_IRQ    : no
periodic_freq   : 1024
batt_status : okay
64

rtc-cmos
lrwxrwxrwx 1 root root      4 Feb 21 01:03 /dev/rtc -> rtc0
crw-r--r-- 1 root root 254, 0 Feb 21 01:03 /dev/rtc0
rtc_time    : 00:03:39
rtc_date    : 2008-02-21
alrm_time   : **:00:10
alrm_date   : ****-**-**
alarm_IRQ   : no
alrm_pending    : no
24hr        : yes
periodic_IRQ    : no
update_IRQ  : yes
DST_enable  : no
periodic_freq   : 1024
batt_status : okay
cat: /proc/sys/dev/rtc/max-user-freq: No such file or directory

So all of them are not completely interchangeable, the only one that works
as expected is 'rtc'.

What am I doing wrong ? Or is it a bug ?


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
