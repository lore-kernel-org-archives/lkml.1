Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbXLNFCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbXLNFCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 00:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXLNFCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 00:02:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:51909 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXLNFCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 00:02:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=PdXPaBzbqvTVtzdjkWXwYf0rkV1opkgYLhMDTPAX9eBTpDVy+5cmwieWpRcfbR2g4gq2AuuJ02cQDUSq0F1tL3q+hlOTbMsOO3cQ9F65Hlau2mMMU43lEDF9yHShGBFS+dHvz2MohMffQyCu6OsB2S62Oyz4LLsWOXYZQtxcSp4=
Message-ID: <47620E5E.5020001@gmail.com>
Date: Fri, 14 Dec 2007 14:02:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: ATA ACPI needs "Mr interpreter, would you please shut up?" flag
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

During 2.6.24-rc1, libata enabled ATA-ACPI support by default and there
have been a lot of regression reports stemming from it.  I have patchset
ready to fix most of the problems.  With these patches applied, libata
should be able to cope with most failures pretty well.  There is one
remaining issue tho.

libata caches the result of _GTM during controller for later use.  The
primary use is to peek at how BIOS configured the controller.  Some
controllers (pata_via and pata_amd) lack proper cable detection and BIOS
configured values are used as reference.  This caching is done before
any other operation is performed on the port to avoid caching corrupted
data.

Problem is that _GTM implementation on certain BIOSen crap themselves if
invoked on empty channels.  However, as written above, because initial
_GTM caching is done before any actual operation is performed on the
port, libata can't determine whether the port is occupied or not when
trying to cache _GTM result.  Unfortunately, VIA PATA is on both
categories - it needs _GTM caching but can't cope with _GTM invocation
on empty ports.  Yay!

libata doesn't need _GTM to succeed.  If the information can be
acquired, it will use it.  If not, it will do just fine without it and
for pata_via, this works perfectly well because the information is
available when actually needed (device present).  The only problem is
that _GTM evaluation failure will print ugly messages during boot.

We can twist ATA probing such that _GTM caching is done between device
detection but before mode is reset to PIO0 but I don't think that's a
good idea for two reasons.  1. That would require pushing PIO0
enforcement after reset.  IMHO, it's wiser to put controller into PIO0
before initiating reset.  2. Presence detection sometimes requires
actually issuing IDENTIFY DEVICE command which in turn needs PIO0
configuration.

So, I think the logical solution here is to tell ACPI interpreter that
the _GTM evaluation may fail and there's no need to alert the user about
that.  Maybe printing with KERN_DEBUG is good enough.  libata can print
additional message after failure (again w/ KERN_DEBUG) telling the user
that there's nothing to worry about.

Thanks.

-- 
tejun
