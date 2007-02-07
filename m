Return-Path: <linux-kernel-owner+w=401wt.eu-S1161380AbXBGQ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161380AbXBGQ0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161377AbXBGQ0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:26:08 -0500
Received: from mx1.suse.de ([195.135.220.2]:52833 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161372AbXBGQ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:26:06 -0500
Message-ID: <45C9FD8C.7020502@suse.de>
Date: Wed, 07 Feb 2007 11:25:48 -0500
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andreas Gruenbacher <agruen@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <200702051813.26958.agruen@suse.de> <1170766539.12293.370.camel@moss-spartans.epoch.ncsc.mil> <200702070055.10856.agruen@suse.de> <20070207154332.GF10574@sequoia.sous-sol.org>
In-Reply-To: <20070207154332.GF10574@sequoia.sous-sol.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Wright wrote:
> * Andreas Gruenbacher (agruen@suse.de) wrote:
>> Reiserfs currently only marks the ".reiserfs_priv" directory as private, but 
>> not the files below it -- how about the attached patch to fix that?
> 
> I don't think that's right.  Look at ->create or ->lookup.  Both of those
> properly set the private flag.  This patch looks like a step backwards,
> sprinkling the init in so many places.

Yeah, this is exactly what happens. The flag is purposely only set once,
and then is inherited up the tree. I'm fine removing the helper
function, but the inheritance should be working fine. Have you seen
behavior that is contrary?

- -Jeff

>> Fix reiserfs xattrs for selinux
>>
>> Mark all inodes used for reiserfs xattrs as private so that selinux
>> (or any other LSM) will not try to mediate access to the files and
>> directories used as the xattr backing store. The xattr operations
>> are already protected through the xattr LSM hooks.
>>
>> There is no real reason for having reiserfs_mark_inode_private --
>> remove it and directly mark the inodes as private.
>>
>> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
>> Cc: Jeff Mahoney <jeffm@suse.de>
>>
>> Index: b/fs/reiserfs/xattr.c
>> ===================================================================
>> --- a/fs/reiserfs/xattr.c
>> +++ b/fs/reiserfs/xattr.c
>> @@ -79,6 +79,7 @@ static struct dentry *create_xa_root(str
>>  			dput(privroot);
>>  			return ERR_PTR(err);
>>  		}
>> +		xaroot->d_inode->i_flags |= S_PRIVATE;
> 
> Already handled in the above ->mkdir
> 
>>  		REISERFS_SB(sb)->xattr_root = dget(xaroot);
>>  	}
>>  
>> @@ -108,6 +109,7 @@ static struct dentry *__get_xa_root(stru
>>  		goto out;
>>  	}
>>  
>> +	xaroot->d_inode->i_flags |= S_PRIVATE;
> 
> Already handled during xa_root creation
> 
>>  	REISERFS_SB(s)->xattr_root = dget(xaroot);
>>  
>>        out:
>> @@ -183,6 +185,7 @@ static struct dentry *open_xa_dir(const 
>>  			return ERR_PTR(-ENODATA);
>>  		}
>>  	}
>> +	xadir->d_inode->i_flags |= S_PRIVATE;
> 
> Already handled in lookup or mkdir
> 
>>  	dput(xaroot);
>>  	return xadir;
>> @@ -235,6 +238,8 @@ static struct dentry *get_xa_file_dentry
>>  	dput(xadir);
>>  	if (err)
>>  		xafile = ERR_PTR(err);
>> +	else
>> +		xafile->d_inode->i_flags |= S_PRIVATE;
> 
> Already handled in lookup or create
> 
>>  	return xafile;
>>  }
>>  
>> @@ -715,6 +720,7 @@ __reiserfs_xattr_del(struct dentry *xadi
>>  		err = -ENODATA;
>>  		goto out_file;
>>  	}
> Already handled in lookup
> 
> etc...


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFFyf2MLPWxlyuTD7IRAnjYAJ40js54LOzv+xMqgSnbfeq6DIvJEACeIWhu
9QuXzrKspwXbh8qSx0o/tK8=
=rvqJ
-----END PGP SIGNATURE-----
