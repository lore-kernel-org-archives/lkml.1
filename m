Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbXBKG1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbXBKG1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXBKG1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:27:01 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:29236 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbXBKG1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:27:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=nW6N1uT58gYDNHKxpk9VE+Ba/pxtAuYv3NklYf0VfxaC0hNG3vLoxRKVt8KZ+B5k23q5qCR/Iyliog5mol21bzuslHlhz4rujyG4FapLhDzFm5gB8k00yakmAlLK8aYaLzmtG2uu7QC1ZYrvJ7rJRBGm8g2UID7WN6++iMbVgiY=
Message-ID: <45CEB720.1020406@gmail.com>
Date: Sun, 11 Feb 2007 01:26:40 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com> <20070211034902.GA9077@infradead.org>
In-Reply-To: <20070211034902.GA9077@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> I haven't looked at what causes it, but any leakage of pci details
> into io.h is bogus.  I'd suggest that the original submitter fixes
> up that problem instead.

pci_iomap() depends on two things - PCI and iomap.  AFAIK, there is no 
config to test whether the current arch supports iomap or not. 
Previously it worked because those archs which don't support either one 
doesn't have set CONFIG_GENERIC_IOMAP while not implementing 
arch-specific ones && not compiling any driver which uses the iomap 
interface.  This is why pci_iomap() ended up in lib/iomap.c in the first 
place; otherwise, it cannot be conditionalized correctly as devers 
currently shows (the 'not implementing arch-specific ones' part cannot 
be easily tested).

So, it seems what we need is either 1. bogus iomap implementation for 
all archs or 2. CONFIG_IOMAP.  Hmmm... I think CONFIG_IOMAP is better as 
it will allow leaving out related devres parts (or any generic function 
using iomap).

-- 
tejun
