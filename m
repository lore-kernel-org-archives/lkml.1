Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZITIQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZITIQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 04:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZITIQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 04:16:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58585 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZITIQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 04:16:04 -0400
Date: Sun, 20 Sep 2009 09:15:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Koskinen Aaro <aaro.koskinen@nokia.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
Message-ID: <20090920081550.GA830@n2100.arm.linux.org.uk>
References: <c9f73fa56a41bc1051cd347cc453081235e3d776.1253307263.git.kirill@shutemov.name> <20090919110316.GA23452@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919110316.GA23452@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 12:03:16PM +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 18, 2009 at 11:55:42PM +0300, Kirill A. Shutemov wrote:
> > It needed for proper prefetch abort handling on ARMv7.
> 
> I think the only thing which is missing is an explaination about why
> this is desirable given that only later CPUs can give this additional
> information.

So you've posted it to the patch system, without further discussion here.

I think the solution is wrong - it makes instruction permission faults
unnecessarily noisy, which is not what the decoding table is supposed
to be doing.  The decoding table's bad entries are there to catch those
_unexpected_ cases.

Instead, I suggest that you have a look at this:

        if (fsr & (1 << 11)) /* write? */
                mask = VM_WRITE;
        else
                mask = VM_READ|VM_EXEC|VM_WRITE;

        fault = VM_FAULT_BADACCESS;
        if (!(vma->vm_flags & mask))
                goto out;

in __do_page_fault - if we are handling a prefetch abort, we really only
want to check that the VMA has VM_EXEC permission, not that it can be
read and written as well.
