Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbZHSEh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbZHSEh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 00:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbZHSEh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 00:37:57 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:44394 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750719AbZHSEh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 00:37:57 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: xZoLZdUVM1nnBqyMvKyk8rDcAA6G39EM2v4RZ6fftqbNgdl2ie1jcDhzP7M69bpMFqMqk0bKlBA7p4_5H2rSmyqPSjelTV4imCjtvEpPzqDw5wAYitBZnTGEEeiU74zurmsXBkdm.WH2W4MUWeWxhAV6ZHBstYsG_xNntvGPYBKOBSI_tIqeQNyMFvN_.VSEliF8U2dvjDN3PcQqxFP2cZzByL1XpkfbrkOuOHqcxEIRzR_4D5RULM7W.NXYV0LuPt1wx.yrfduV5XGZB6l53dhgCUBrXxU2s6UjvKpLkBIR4i1qskngoToTxAmNnvVXwOfJdwsHj6ITa9L3n_Fp9eOo0WrHqsrkXLY-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A8B81A0.6070206@schaufler-ca.com>
Date: Tue, 18 Aug 2009 21:37:52 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Security/sysfs: v2 - Enable security xattrs to be set
 on sysfs files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	 <4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>	 <4A861291.1030404@schaufler-ca.com> <m1tz09j00q.fsf@fess.ebiederm.org>	 <4A864008.50907@schaufler-ca.com> <m1my61sjie.fsf@fess.ebiederm.org>	 <4A8A2616.8020809@schaufler-ca.com>	 <1250597660.3629.204.camel@moss-pluto.epoch.ncsc.mil>	 <4A8AB6B0.8010800@schaufler-ca.com> <1250605386.3629.236.camel@moss-pluto.epoch.ncsc.mil>
In-Reply-To: <1250605386.3629.236.camel@moss-pluto.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> On Tue, 2009-08-18 at 07:12 -0700, Casey Schaufler wrote:
>   
>> Stephen Smalley wrote:
>>     
>>> On Mon, 2009-08-17 at 20:55 -0700, Casey Schaufler wrote:
>>>   
>>>       
>>>> From: Casey Schaufler <casey@schaufler-ca.com>
>>>>
>>>> Another approach to limited xattr support in sysfs.
>>>>
>>>> I tried to listen to the objections to a linked list representation
>>>> and I think that I understand that there isn't really any interest
>>>> in supporting xattrs for real, only for those maintained by LSMs.
>>>> I also looked carefully into the claims that memory usage is
>>>> critical and that the code I had before was duplicating effort.
>>>>
>>>> This version lets the surrounding code do as much of the work as
>>>> possible. Unlike the initial proposal for sysfs xattrs, it does not
>>>> introduce any new LSM hooks, it uses hooks that already exist. It
>>>> does not support any attributes on its own, it only provides for
>>>> the attribute advertised by security_inode_listsecurity(). It could
>>>> easily be used by other filesystems to provide the same LSM xattr
>>>> support. It could also be extended to do the list based support for
>>>> arbitrary xattrs without too much effort.
>>>>
>>>> Probably the oddest bit is that the inode_getsecurity hooks need to
>>>> check to see if they are getting called before the inode is instantiated
>>>> and return -ENODATA in that event. It would be possible to do a
>>>> filesystem specific check instead, but this way provides for generally
>>>> correct behavior at small cost.
>>>>
>>>> This has been tested with Smack, but not SELinux. I think that
>>>> SELinux will work correctly, but it could be that a labeling
>>>> behavior that is different than the "usual" instantiation labeling
>>>> is actually desired. That would be an easy change.
>>>>
>>>> As always, let me know if I missed something obvious or if there's a
>>>> fatal flaw in the scheme.
>>>>     
>>>>         
>>> The point of the David's patch was to provide a way to save the security
>>> xattr in the backing data structure for sysfs entries when an attribute
>>> value is set from userspace so that the value can be preserved if the
>>> inode is evicted from memory and later re-instantiated.  AFAICS, your
>>> patch completely misses the problem.  How about we just go back to
>>> David's patch?
>>>   
>>>       
>> Oh no, that would use too much memory!
>>
>> Either you care about the value the user set, in which case you
>> want to save the value the user set, or you don't. If you do, you
>> have to save that value, not an LSM's interpretation of that value.
>> No secids. No new hooks.
>>     
>
> As the security module is the only component of the kernel that
> uses/interprets that value, it isn't unreasonable for the security
> module's interpretation of that value to be considered canonical.  In
> fact, that is already the case - the hooks within vfs_getxattr() enable
> the security module to override/replace the actual security xattr value
> returned to userspace.
>
> In the case of Smack, Smack could just provide a pointer to its own
> internal copy of the string, and that could be stored in the wrapped
> iattr.  In the case of SELinux, we could provide a secid that could be
> stored in the wrapped iattr.  The hook interface could just handle it as
> a blob if you prefer.  But either way we don't need extra storage aside
> from a pointer-size field in the wrapped iattr.
>   

So how often is the SELinux label going to get explicitly set in /sys ?
I'm grappling with the value of going hog-wild in optimizing this. If
it is something that's quite rare I can see the concern with expanding
the d_entry. If it is common, the storage associated with storing the
xattr could be an issue. If it is uncommon but not rare there's another
story again.

I'm looking at addressing the issues. Thank you.

