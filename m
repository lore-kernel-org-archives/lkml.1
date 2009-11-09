Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZKIPUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZKIPUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZKIPUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:20:41 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:38741 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZKIPUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:20:41 -0500
MIME-Version: 1.0
In-Reply-To: <1257292099-15802-12-git-send-email-john.johansen@canonical.com>
References: <1257292099-15802-1-git-send-email-john.johansen@canonical.com>
	 <1257292099-15802-12-git-send-email-john.johansen@canonical.com>
Date: Mon, 9 Nov 2009 10:20:45 -0500
Message-ID: <7e0fb38c0911090720h6c244badmb635768bb16c4a55@mail.gmail.com>
Subject: Re: [PATCH 11/12] AppArmor: LSM interface, and security module 
	initialization
From: Eric Paris <eparis@parisplace.org>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 6:48 PM, John Johansen
<john.johansen@canonical.com> wrote:
> AppArmor hooks to interface with the LSM, and module parameters and
> initialization.
>
> Signed-off-by: John Johansen <john.johansen@canonical.com>
> ---


> +static int apparmor_file_mmap(struct file *file, unsigned long reqprot,
> +                             unsigned long prot, unsigned long flags,
> +                             unsigned long addr, unsigned long addr_only)
> +{
> +       int rc = 0;
> +       struct aa_profile *profile = aa_current_profile_wupd();
> +       /*
> +        * test before cap_file_mmap.  For confined tasks AppArmor will
> +        * enforce the mmap value set in the profile or default
> +        * to LSM_MMAP_MIN_ADDR
> +        */
> +       if (profile) {
> +               if (profile->flags & PFLAG_MMAP_MIN_ADDR) {
> +                       if (addr < profile->mmap_min_addr)
> +                               rc = -EACCES;
> +               } else if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
> +                       rc = -EACCES;
> +               }
> +               if (rc) {
> +                       struct aa_audit sa = {
> +                               .operation = "file_mmap",
> +                               .gfp_mask = GFP_KERNEL,
> +                               .info = "addr < mmap_min_addr",
> +                               .error = rc,
> +                       };
> +                       return aa_audit(AUDIT_APPARMOR_DENIED, profile, &sa,
> +                                       NULL);
> +               }
> +       }
> +       rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
> +       if (rc || addr_only)
> +               return rc;
> +
> +       return common_mmap(file, "file_mmap", prot, flags);
> +}

There is a reason we do the round_hint_to_min() stuff in the vm and we
recalculate that value every time dac_mmap_min_addr is change.  It's
because mmap (NOT MAP_FIXED) with a hint < profile->mmap_min_addr is
going to end up getting denied here since the VM is going to assign it
the address it wanted instead of find a new address and you are going
to deny that task.

If profile() is a per task thing, I think you are in a failed
situation and can't solve the problem wtihout intrusive VFS hooks.  If
profile is a global thing just update that global value.  In either
case, this code is wrong....

-Eric
