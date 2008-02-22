Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYBVHXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYBVHXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYBVHXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:23:33 -0500
Received: from www.tglx.de ([62.245.132.106]:38411 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbYBVHXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:23:32 -0500
Date: Fri, 22 Feb 2008 08:23:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Quel Qun <kelk1@comcast.net>
cc: Dave Young <hidave.darkstar@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
In-Reply-To: <022220080240.25836.47BE362900072A1C000064EC2200761394CE05040A05@comcast.net>
Message-ID: <alpine.LFD.1.00.0802220813180.7583@apollo.tec.linutronix.de>
References: <022220080240.25836.47BE362900072A1C000064EC2200761394CE05040A05@comcast.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quel,

On Fri, 22 Feb 2008, Quel Qun wrote:
> $ addr2line -e vmlinux c012d51d
> /usr/src/linux-2.6.25-rc2-git5kk1/kernel/timer.c:770
> 
> Crap, that is on the next list_for_each_entry in timer.c :(
> 
> I tried to make a similar test loop as you did a few lines above:

Cool.
 
> I thought I got it on the next crash, but the system locked too
>  fast, and the only thing I saw was:
> 
> TTRACE timer f7b52858 fn f8e7c608 addr c012d776
> TTRACE fn l2cap_info_timeout
> TTRACE addr mod_timer
> BUG: unable to handle kernel paging request at 6b6b6b6b

That's what I wanted to see.
 
> I hope the tiny bit of trace can trigger some idea. At least l2cap
> has something to do with bluetooth. l2cap_info_timeout is line 360
> of net/bluetooth/l2cap.c, apparently only called from
> l2cap_conn_add, line 391: setup_timer(&conn->info_timer,
> l2cap_info_timeout, (unsigned long)conn);

Correct. And I don't see how it's guaranteed that the timer is deleted
before l2cap_conn_del() is called which kfree's the l2cap_conn
structure.

> After four hours and ten crashes today, it is the little I
> got. Kernel stuff is tough...

Yes, it is. The little information you got should be enough to solve
this. Thanks for your patience and help !

Does the patch below fix your problem ?

Thanks,

	tglx

---
 net/bluetooth/l2cap.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/net/bluetooth/l2cap.c
===================================================================
--- linux-2.6.orig/net/bluetooth/l2cap.c
+++ linux-2.6/net/bluetooth/l2cap.c
@@ -417,6 +417,8 @@ static void l2cap_conn_del(struct hci_co
 		l2cap_sock_kill(sk);
 	}
 
+	del_timer(&conn->info_timer);
+
 	hcon->l2cap_data = NULL;
 	kfree(conn);
 }
