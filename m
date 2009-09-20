Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZITJfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZITJfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 05:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbZITJfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 05:35:17 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:61653 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbZITJfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 05:35:16 -0400
MIME-Version: 1.0
In-Reply-To: <20090920081550.GA830@n2100.arm.linux.org.uk>
References: <c9f73fa56a41bc1051cd347cc453081235e3d776.1253307263.git.kirill@shutemov.name>
	 <20090919110316.GA23452@n2100.arm.linux.org.uk>
	 <20090920081550.GA830@n2100.arm.linux.org.uk>
Date: Sun, 20 Sep 2009 12:35:19 +0300
Message-ID: <cc557aab0909200235sbb4c1f5tdc84434732222988@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Koskinen Aaro <aaro.koskinen@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 11:15 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Sep 19, 2009 at 12:03:16PM +0100, Russell King - ARM Linux wrote:
>> On Fri, Sep 18, 2009 at 11:55:42PM +0300, Kirill A. Shutemov wrote:
>> > It needed for proper prefetch abort handling on ARMv7.
>>
>> I think the only thing which is missing is an explaination about why
>> this is desirable given that only later CPUs can give this additional
>> information.
>
> So you've posted it to the patch system, without further discussion here.
>
> I think the solution is wrong - it makes instruction permission faults
> unnecessarily noisy, which is not what the decoding table is supposed
> to be doing.  The decoding table's bad entries are there to catch those
> _unexpected_ cases.
>
> Instead, I suggest that you have a look at this:
>
>        if (fsr & (1 << 11)) /* write? */
>                mask = VM_WRITE;
>        else
>                mask = VM_READ|VM_EXEC|VM_WRITE;
>
>        fault = VM_FAULT_BADACCESS;
>        if (!(vma->vm_flags & mask))
>                goto out;
>
> in __do_page_fault - if we are handling a prefetch abort, we really only
> want to check that the VMA has VM_EXEC permission, not that it can be
> read and written as well.
>

Ok, so __do_page_fault() should know where we are: in data abort or in
prefetch abort. What is right way to do it? Should we create one more
argument or use one of reserved bits IFSR?
