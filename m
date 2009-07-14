Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZGNDHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZGNDHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 23:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZGNDHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 23:07:06 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:35634 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752562AbZGNDHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 23:07:05 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: fXebX7gVM1kwuykCArzlvoauhFyBQmiTYTiMd9f0F80L3z5Z9FJ3sFZfGcJajES1Zfb9gsWCZDxMlkGjlcJaHS0lVPjoTeEWL0oXxLf2GpdSy8oqRU7r3Kb7P8N3yzN_L1xVDzCxd_VWbBHRVEe.lUUc_wk2ySgAwK4sCy.cIU6bng3XS2yoDRITFg6IV9htAqnTgql7amHsiahSwRaHAR5i9hlaMSVuGI4EvVpPNyEfnliRFDjd98BXTz7_B_pZuv92n76y1ayctucKpVq.mx7bsn4kSB_swp9cBYlWtwn2R7zexo2uPyNrwy7EVxB7ptmB5g--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A5BF621.2050309@schaufler-ca.com>
Date: Mon, 13 Jul 2009 20:06:09 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, jmorris@namei.org,
       gregkh@suse.de, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>	 <m1r5wmnee0.fsf@fess.ebiederm.org> <1247498399.4398.259.camel@localhost>	 <m1zlb8a5n5.fsf@fess.ebiederm.org> <1247512705.4398.292.camel@localhost>
In-Reply-To: <1247512705.4398.292.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> Looking at the sysfs code I can see where the inode gets its default
> values for everything but uid and gid. Are those set somewhere higher up
> in the vfs on the init_inode path? The approach does seem reasonable but
> do we want to have to allocate an entire iattr structure inside the
> sysfs_inode_attr structure you propose just to store the secid? 
>
>   
>>>>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>>>>> index 2081055..395c36d 100644
>>>>> --- a/security/selinux/hooks.c
>>>>> +++ b/security/selinux/hooks.c
>>>>> @@ -448,6 +448,10 @@ static int sb_finish_set_opts(struct super_block *sb)
>>>>>  	    sbsec->behavior > ARRAY_SIZE(labeling_behaviors))
>>>>>  		sbsec->flags &= ~SE_SBLABELSUPP;
>>>>>  
>>>>> +	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
>>>>> +	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
>>>>> +		sbsec->flags |= SE_SBLABELSUPP;
>>>>>           
>>>> What is this about?  My impression is that if we have generic xattr
>>>> handling sysfs is not special so why do we have a special case?
>>>>
>>>> Is this interface appropriate for dealing with xattrs to all
>>>> linux virtual filesystmes similar to sysfs that do not currently
>>>> implement xattrs. aka debugfs, proc, etc?
>>>>         
>>> Even though sysfs has a setxattr handler the labeling behavior with
>>> respect to SELinux needs special handling. The idea here is that by
>>> default sysfs will be labeled across the board with the same label. The
>>> reason we can't use a normal style xattr handler here is because there
>>> is no original backing store to pull the label from. Only after a label
>>> has been changed is there a semi-persistent value that can be used for
>>> reinstantiating the inode in the case that it is pruned from the cache.
>>> Otherwise it falls back to the base genfs labeling of sysfs entries as
>>> sysfs_t.
>>>       
>> Sounds like we want a mount option or the like here.  Something explicit
>> in sysfs not something explicit in the security module.
>>
>> I am also a bit dubious about 
>>     
>
> I don't think a mount option is the best thing here. Labeling behavior
> is something that is LSM dependent and even file system dependent within
> certain LSMs. Since I don't speak for Casey that the way SELinux handles
> sysfs is the way he want's Smack handling sysfs, and we can't tell what
> future label based LSMs will do I think leaving it to the module to
> decide is best.
>
>   

My preference would be to stop having to do special case handling for
file systems that don't support xattrs. The obvious way to address the
situation would be generic support for xattrs in memory based file
systems. Yes, there would be bookkeeping to do, and yes, there would
be memory fragmentation issues to consider. But really, all we're
talking about is maintaining a list of name/value pairs on the
file system entry. The machinery for doing the work is all already
there. The LSMs already know how to initialize xattrs that they care
about. If there's a problem it will be with LSMs that count on the
lack of proper labeling when using these file systems.

No new hooks required. Rather than putting in a special case for
a file system that does not support xattrs, how about we solve the
problem and fix the real issue, which is the file systems that don't
support them?

The Smack project is running somewhat lean right now, but I could
shift some resources around (multi-label window managers are a pain
anyhow) if that is what it takes.


>>     
>>> Proc also has some special case handling in the SELinux module but I
>>> haven't had a chance to look at it and try to understand why. I don't
>>> think that this would be a general purpose solution for all pseudo file
>>> systems like you mentioned above but it may work for some of them. I'll
>>> look into them a bit more and then respond about them.
>>>       
>> Sounds good.  If we are going to expand the LSM it would be good to design
>> something decent instead of adding a nasty add-hoc case.
>>     
>
> A quick look over proc and debugfs leads me to believe that a generic
> mechanism for all of them short of adding generic xattr support to all
> pseudo file systems would be tricky at best and even more add-hoc than
> what we already do. There isn't any uniformity in the data structures
> that are used in these file systems so even if we came up with a lazy
> update mechanism for these attributes it looks like the implementation
> would vary greatly depending on the file system. Even then it doesn't
> change the add-hoc nature of the functionality as we are only trying to
> handle security attributes. 
>
> The real solution which is a lot of work and I don't exactly know how I
> would go about putting it together is to try to provide a generic xattr
> mechanism for pseudo file systems. However I don't have any use cases
> for the majority of the xattr name spaces. The only thing we have at the
> moment that needs attention and only on sysfs is the security.* name
> space. So trying to implement full-blown xattrs on sysfs seems like a
> bunch of effort with no clear user for it.
>
>   
>> And on a silly note.  Rumor has it that selinux has provable security.
>> If so what impact does this change make to the proofs?
>>
>>     
>
> I'm not a formal methods person so you would have to consult with the
> people who did that work to find out.
>
>
>   
>> Eric
>>     
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   
