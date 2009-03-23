Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbZCWDy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbZCWDy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 23:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZCWDyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 23:54:17 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:33273 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbZCWDyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 23:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903230130200.10796@blonde.anvils>
References: <Pine.LNX.4.64.0903221826520.17976@blonde.anvils>
	 <aca0ce8b0903221356w487dbbbdie6d5cb9a1862af57@mail.gmail.com>
	 <Pine.LNX.4.64.0903230130200.10796@blonde.anvils>
Date: Sun, 22 Mar 2009 20:54:12 -0700
Message-ID: <aca0ce8b0903222054g5f0778ecr6ea2db718599359c@mail.gmail.com>
Subject: Re: [PATCH next] sysfs: fix some bin_vm_ops errors
From: Eric Biederman <ebiederm@aristanetworks.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 6:41 PM, Hugh Dickins <hugh@veritas.com> wrote:
> On Sun, 22 Mar 2009, Eric Biederman wrote:
>> On Sun, Mar 22, 2009 at 11:33 AM, Hugh Dickins <hugh@veritas.com> wrote:
>>
>> > If the file being mmap'ed is a shmem/tmpfs file, don't fail the mmap
>> > on CONFIG_NUMA=y, just because that has a set_policy and get_policy.
>> > They probably won't be called, and it's not a disaster if they don't
>> > work on sysfs.  vm_ops->migrate?  I couldn't find any example.  Just
>> > delete CONFIG_NUMA tests, easy enough to add stubs later if required.
>>
>> I agree about it being easy enough to add stubs later if required.  In my case
>> I deliberately added an error check instead so that the code would fail fast
>> instead of failing subtlely if anyone ever did that.  And that check appears
>> to have worked in your case so I would like to retain that check.
>
> No, I didn't really hit that case (I didn't even have CONFIG_NUMA=y),
> it was just one of the several misguesses I made before hitting on the
> right answer.
>
> I can understand you preferring to keep a check on this, but I don't
> believe you really want to retain _that_ check: it just causes some
> mmaps to fail on CONFIG_NUMA=y configurations, which succeed on
> non-NUMA configurations, and work fine on non-NUMA configurations,
> so long as you don't try set_policy, get_policy or migrate.
>
> Here's a replacement version of the patch which adds those methods,
> and adds a comment on the substituted vm_file as Ben suggests.
>
>
> [PATCH next] sysfs: fix some bin_vm_ops errors
>
> Commit 86c9508eb1c0ce5aa07b5cf1d36b60c54efc3d7a
> "sysfs: don't block indefinitely for unmapped files" in linux-next
> crashes the PowerMac G5 when X starts up.  It's caught out by the way
> powerpc's pci_mmap of legacy_mem uses shmem_zero_setup(), substituting
> a new vma->vm_file whose private_data no longer points to the bin_buffer
> (substitution done because some versions of X crash if that mmap fails).
>
> The fix to this is straightforward: the original vm_file is fput() in
> that case, so this mmap won't block sysfs at all, so just don't switch
> over to bin_vm_ops if vm_file has changed.
>
> But more fixes made before realizing that was the problem:-
>
> It should not be an error if bin_page_mkwrite() finds no underlying
> page_mkwrite().
>
> Check that a file already mmap'ed has the same underlying vm_ops
> _before_ pointing vma->vm_ops at bin_vm_ops.
>
> If the file being mmap'ed is a shmem/tmpfs file, don't fail the mmap
> on CONFIG_NUMA=y, just because that has a set_policy and get_policy:
> provide bin_set_policy, bin_get_policy and bin_migrate.
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> I have only tested that X now starts up fine on the G5: I don't think
> I've messed up the intent of your patch, but not tested it still works.

Looks reasonable to me.
Acked-by: Eric Biederman <ebiederm@aristanetworks.com>

Eric
