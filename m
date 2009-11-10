Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZKJSiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZKJSiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbZKJSiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:38:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34094 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606AbZKJSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:38:50 -0500
Message-ID: <4AF9B33D.5020908@canonical.com>
Date: Tue, 10 Nov 2009 10:38:53 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 11/12] AppArmor: LSM interface, and security module 	initialization
References: <1257292099-15802-1-git-send-email-john.johansen@canonical.com>	 <1257292099-15802-12-git-send-email-john.johansen@canonical.com> <7e0fb38c0911090720h6c244badmb635768bb16c4a55@mail.gmail.com>
In-Reply-To: <7e0fb38c0911090720h6c244badmb635768bb16c4a55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Tue, Nov 3, 2009 at 6:48 PM, John Johansen
> <john.johansen@canonical.com> wrote:
>> AppArmor hooks to interface with the LSM, and module parameters and
>> initialization.
>>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
>> ---
> 
> 
>> +static int apparmor_file_mmap(struct file *file, unsigned long reqprot,
>> +                             unsigned long prot, unsigned long flags,
>> +                             unsigned long addr, unsigned long addr_only)
>> +{
>> +       int rc = 0;
>> +       struct aa_profile *profile = aa_current_profile_wupd();
>> +       /*
>> +        * test before cap_file_mmap.  For confined tasks AppArmor will
>> +        * enforce the mmap value set in the profile or default
>> +        * to LSM_MMAP_MIN_ADDR
>> +        */
>> +       if (profile) {
>> +               if (profile->flags & PFLAG_MMAP_MIN_ADDR) {
>> +                       if (addr < profile->mmap_min_addr)
>> +                               rc = -EACCES;
>> +               } else if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
>> +                       rc = -EACCES;
>> +               }
>> +               if (rc) {
>> +                       struct aa_audit sa = {
>> +                               .operation = "file_mmap",
>> +                               .gfp_mask = GFP_KERNEL,
>> +                               .info = "addr < mmap_min_addr",
>> +                               .error = rc,
>> +                       };
>> +                       return aa_audit(AUDIT_APPARMOR_DENIED, profile, &sa,
>> +                                       NULL);
>> +               }
>> +       }
>> +       rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
>> +       if (rc || addr_only)
>> +               return rc;
>> +
>> +       return common_mmap(file, "file_mmap", prot, flags);
>> +}
> 
> There is a reason we do the round_hint_to_min() stuff in the vm and we
> recalculate that value every time dac_mmap_min_addr is change.  It's
> because mmap (NOT MAP_FIXED) with a hint < profile->mmap_min_addr is
> going to end up getting denied here since the VM is going to assign it
> the address it wanted instead of find a new address and you are going
> to deny that task.
> 
> If profile() is a per task thing, I think you are in a failed
> situation and can't solve the problem wtihout intrusive VFS hooks.  If
> profile is a global thing just update that global value.  In either
> case, this code is wrong....
> 
yep, thanks for pointing this out.  I will look into it.

john
