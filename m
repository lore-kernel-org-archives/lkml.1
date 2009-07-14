Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZGNOp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZGNOp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZGNOpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:45:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbZGNOpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:45:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: access_ok macor
Date: Tue, 14 Jul 2009 16:45:48 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
References: <4A5C8068.6020203@monstr.eu> <200907141521.47719.arnd@arndb.de> <4A5C8BF2.8020505@monstr.eu>
In-Reply-To: <4A5C8BF2.8020505@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907141645.48833.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+aDOT3BI330/vDPu583lut43U8tdRzWeTZ2Vf
 Pj9Z+YPE7xR27G0G5zblGVVPfW0dTriIrslAUL/wEEu6k2qXP+
 UybcyjEzdqFEYnPtyS+2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 July 2009, Michal Simek wrote:
> Arnd Bergmann wrote:
> Look at
> http://developer.petalogix.com/git/gitweb.cgi?p=ltp-microblaze.git;a=commitdiff;h=45f4cd783ce8b94f1267bb87c0c46e8536f62eca
> 
> There are three affected tests and my quick fixes which I am trying to solve now.
> 

ok, I see.
 
> int move_addr_to_user(struct sockaddr *kaddr, int klen, void __user *uaddr,
> 		      int __user *ulen)
> {
> 	int err;
> 	int len;
> 
> 	err = get_user(len, ulen);
> 	if (err)
> 		return err;
> 

So the code looks something like

                        "1:     lw      %1, %2, r0;                     \
                                addk    %0, r0, r0;                     \
                        2:                                              \
                        .section .fixup,\"ax\";                         \
                        3:      brid    2b;                             \
                                addik   %0, r0, %3;                     \
                        .previous;                                      \
                        .section ,\"a\";                      		\
                        .word   1b,3b;                                  \
                        .previous;"                                     \

Not much that can go wrong there. First of all, I'd check that the
code actually looks the same in the binary. I assume that the 'addik'
gets executed when the brid branches, right?

I would guess that some of the logic in do_page_fault might be
broken and does not actually call the fixup.

	Arnd <><
