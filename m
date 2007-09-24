Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbXIXPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbXIXPCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbXIXPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:02:07 -0400
Received: from tornado.reub.net ([210.185.126.1]:53963 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbXIXPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:02:06 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2007 11:02:06 EDT
Message-ID: <46F7CF2E.9030609@reub.net>
Date: Tue, 25 Sep 2007 00:52:30 +1000
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0.0.7pre (Windows/20070922)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/09/2007 7:17 PM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> 
> - New git tree git-powerpc-galak.patch added to the -mm lineup: ppc32
>   things, mainly (Kumar Gala <galak@gate.crashing.org>)

I'm observing a problem with this kernel (as well as 2.6.23-rc6-mm1) which 
manifests itself only in my Postfix/application mail.logs:

Sep 25 00:25:40 tornado postfix/smtp[12520]: fatal: select lock: Cannot allocate 
memory
Sep 25 00:25:41 tornado postfix/master[8002]: warning: process 
/usr/lib64/postfix/smtp pid 12520 exit status 1

This is happening frequently with processes started via 'master' (smtp, smtpd 
and cleanup), but it does not appear to have any noticeable operational impact 
apart from logging a lot of copies of this message.

The corresponding code in Postfix which triggers this is (choice of 3 files in 
src/master are all possibilities which all have much the same code)

     /*
      * The event loop, at last.
      */
     while (var_use_limit == 0 || use_count < var_use_limit || client_count > 0) {
         if (multi_server_lock != 0) {
             watchdog_stop(watchdog);
             if (myflock(vstream_fileno(multi_server_lock), INTERNAL_LOCK,
                         MYFLOCK_OP_EXCLUSIVE) < 0)
                 msg_fatal("select lock: %m");
         }
         watchdog_start(watchdog);
         delay = loop ? loop(multi_server_name, multi_server_argv) : -1;
         event_loop(delay);
     }
     multi_server_exit();
}


Now I'm not convinced this is an application problem, because I'm only seeing 
this after running up kernel 2.6.23-rc6-mm1 or 2.6.23-rc7-mm1 and with NO 
changes to the application itself.  Using the same application binaries it does 
not occur with 2.6.22 mainline.  [I didn't get a lot of testing with the -mm 
release prior to that unfortunately due to some other breakage.]

Is there anything new in the last two or so -mm kernels which could have caused 
this?

I've put my .config up at http://www.reub.net/files/kernel/2.6.23-rc7-mm1.config

Thanks,
Reuben
