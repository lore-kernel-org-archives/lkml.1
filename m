Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZJ0DYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZJ0DYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZJ0DYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:24:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41275 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZJ0DYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:24:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Oct 2009 12:22:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vedran.furac@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Memory overcommit
Message-Id: <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4AE5CB4E.4090504@gmail.com>
References: <hav57c$rso$1@ger.gmane.org>
	<20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>
	<hb2cfu$r08$2@ger.gmane.org>
	<20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>
	<4ADE3121.6090407@gmail.com>
	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
	<4AE5CB4E.4090504@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__27_Oct_2009_12_22_13_+0900_mF=J5nn4APaaG3/k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Tue__27_Oct_2009_12_22_13_+0900_mF=J5nn4APaaG3/k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 26 Oct 2009 17:16:14 +0100
Vedran Furač <vedran.furac@gmail.com> wrote:
> >  - Could you show me /var/log/dmesg and /var/log/messages at OOM ?
> 
> It was catastrophe. :) X crashed (or killed) with all the programs, but
> my little program was alive for 20 minutes (see timestamps). And for
> that time computer was completely unusable. Couldn't even get the
> console via ssh. Rally embarrassing for a modern OS to get destroyed by
> a 5 lines of C run as an ordinary user. Luckily screen was still alive,
> oomk usually kills it also. See for yourself:
> 
> dmesg: http://pastebin.com/f3f83738a
> messages: http://pastebin.com/f2091110a
> 
> (CCing to lklm again... I just want people to see the logs.)
> 
Thank you for reporting and your patience. It seems something strange
that your KDE programs are killed. I agree.

I attached a scirpt for checking oom_score of all exisiting process.
(oom_score is a value used for selecting "bad" processs.")
please run if you have time.

This is a result of my own desktop(on virtual machine.)
In this environ (Total memory is 1.6GBytes), mmap(1G) program is running.

%check_badness.pl | sort -n | tail
--
89924	3938	mixer_applet2
90210	3942	tomboy
94753	3936	clock-applet
101994	3919	pulseaudio
113525	4028	gnome-terminal
127340	1	init
128177	3871	nautilus
151003	11515	bash
256944	11653	mmap
425561	3829	gnome-session
--
Sigh, gnome-session has twice value of mmap(1G).
Of course, gnome-session only uses 6M bytes of anon.
I wonder this is because gnome-session has many children..but need to
dig more. Does anyone has idea ?
(CCed kosaki)

Thanks,
-Kame





--Multipart=_Tue__27_Oct_2009_12_22_13_+0900_mF=J5nn4APaaG3/k
Content-Type: text/x-perl;
 name="check_badness.pl"
Content-Disposition: attachment;
 filename="check_badness.pl"
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl

open(LINE, "ps -A -o pid,comm | grep -v PID|") || die "can't ps";

while (<LINE>) {
	/^\s*([0-9]+)\s+(.*)$/;
	$PID=$1;
	$COMM=$2;
	open(SCORE, "/proc/$PID/oom_score") || next;
	$oom_score = <SCORE>;
	chomp($oom_score);
	close(SCORE);
	print $oom_score."\t".$PID . "\t",$COMM."\n";
}
close(LINE);

--Multipart=_Tue__27_Oct_2009_12_22_13_+0900_mF=J5nn4APaaG3/k--

