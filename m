Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYBYPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYBYPqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYBYPqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:46:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbYBYPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:46:35 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
To: Andi Kleen <andi@firstfloor.org>, Marcel Holtmann <marcel@holtmann.org>,
       Simon Richter <sjr@debian.org>, Tilman Schmidt <tilman@imap.cc>,
       Gregory Nietsky <gregory@networksentry.co.za>,
       Jeff Garzik <jeff@garzik.org>, kkeil@suse.de, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       Sam Ravnborg <sam@ravnborg.org>
Reply-To: 7eggert@gmx.de
Date: Mon, 25 Feb 2008 16:45:42 +0100
References: <9XBPP-6LJ-23@gated-at.bofh.it> <9XXQl-7or-3@gated-at.bofh.it> <9Y67a-3ta-9@gated-at.bofh.it> <9YcYY-63L-25@gated-at.bofh.it> <9YwuJ-3a7-17@gated-at.bofh.it> <9YxqU-4Ge-11@gated-at.bofh.it> <9YY7F-5bH-13@gated-at.bofh.it> <9ZhtN-2cL-51@gated-at.bofh.it> <9ZpAK-6CQ-25@gated-at.bofh.it> <9ZsS5-3zh-21@gated-at.bofh.it> <9Ztbm-3XZ-1@gated-at.bofh.it> <9Ztbq-3XZ-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JTfWQ-0003o5-M6@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18SZU7RXfZQtGR1nbm23jN2rEuloyfoqJimCIE
 gMlD8lh3d1VZtpUfnfibDeu3KVS4BTnfjR/cP/lRD05xWrILTY
 idH54XPcHduwdWFV3ImHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

>> we were talking about the load order. This will solve the load order,
>> but if we have races like the kind you described, then the whole mISDN
>> design is broken.
> 
> It's more a generic problem of the module code.

It's a problem of not enough synchronisation before a module load completes.

If a module provides an interface, but needs some time after being load to
initialize, it obviously MUST provide a way to wait for it. Since you'll
need some i-need-module-foo functions anyway, why not: (bar needs foo)

-foo.c---
DECLARE_COMPLETION(init_complete); /* static? */
module_foo_init_async() {
        ...
        void complete_all(&init_complete);
}

void usemod_foo()
{
        wait_for_completion(&init_complete);
}
EXPORT_SYMBOL(usemod_foo)

-bar.c---
DECLARE_COMPLETION(init_complete);
module_bar_init_async() {
        usemod_foo();
        ...
        void complete_all(&init_complete);
}

void usemod_bar()
{
        wait_for_completion(&init_complete);
}
EXPORT_SYMBOL(usemod_bar)


