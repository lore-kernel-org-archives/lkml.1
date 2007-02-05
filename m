Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbXBEUKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbXBEUKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbXBEUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:10:06 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4089 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbXBEUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:10:05 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Feb 2007 12:10:02 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Zach Brown <zach.brown@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
Message-ID: <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org>
 <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
 <20070203082308.GA6748@elte.hu> <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Zach Brown wrote:

> > The "result" of one async operation is basically a cookie and a result
> > code. Eight or sixteen bytes at most.
> 
> s/basically/minimally/
> 
> Well, yeah.  The patches I sent had:
> 
> struct asys_completion {
>        long            return_code;
>        unsigned long   cookie;
> };
> 
> That's as stupid as it gets.

No, that's *really* it ;)
The cookie you pass, and the return code of the syscall.
If there other data transfered? Sure, but that data transfered during the 
syscall processing, and handled by the syscall (filling up a sys_read 
buffer just for example).




> > IMO, before going wacko designing
> > complex shared userspace-kernel result buffers, I think it'd be better
> > measuring the worth-value of the thing ;)
> 
> Obviously, yes.
> 
> The potential win is to be able to have one place to wait for collection from
> multiple sources.  Some of them might want more data per event.  They can
> always indirect out via a cookie pointer,  sure, but at insanely high message
> rates (10gige small messages) one might not want that.

Did I miss something? The async() syscall will allow (with few 
restrictions) to execute whatever syscall in an async fashion. An syscall 
returns a result code (long). Plus, you need to pass back the 
userspace-provided cookie of course. A cookie is very likely a direct 
pointer to the userspace session the async syscall applies to, so a
"(my_session *) results[i].cookie" will bring you directly on topic.
Collection of multiple sources? What do you mean? What's wrong with:

int async_wait(struct asys_completion *results, int nresults);

Is saving an 8/16 bytes double copy worth going wacko in designing shared 
userspace/kernel buffers, when the syscall that lays behind an 
asys_completion is prolly touching KBs of RAM during its execution?




- Davide


