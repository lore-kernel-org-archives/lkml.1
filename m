Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbZGIO4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbZGIO4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbZGIO4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:56:13 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:30680 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757116AbZGIO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:56:12 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2009 10:56:12 EDT
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: AnYvZs4VM1lYsD1fLD1nJGKcn9f8PxI8U56YeQdhFjwIq0rlURDxyIGWec4oHRYBZIAFRS2pzaD2P6yyn7zD8sZcFR7wRT0dA8pLF663.sSBb.AiOAcAcKSTsLNG0.pHt9KXX.rbxZK9GNonpf4E1BLHXdAOMBaFV1SXWzBpqsPNE0F14qK3NnA4Ko2Ep.eWB.joSWreTqwqb9DKQszSgNQdSlXvzACjjBPgGQ.CWdYv5UpR7XCNhQHkKqpFdFhFEtQlmQ8UhZXwqyZUkF5_gW6ltaeZJ8SfjYFaeYVYUWgegDydy7xhSw6Angn2cHkRO4RKEJKZmQJmr2fe5AX9Inp1kZy4zGoyZdqNYZo0M8VeBD_qMYcHqNTQEeIHyzE-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A560363.6050304@schaufler-ca.com>
Date: Thu, 09 Jul 2009 07:49:07 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: jmorris@namei.org, gregkh@suse.de, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>	 <4A554B95.6070709@schaufler-ca.com> <1247148306.4398.157.camel@localhost>
In-Reply-To: <1247148306.4398.157.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> On Wed, 2009-07-08 at 18:44 -0700, Casey Schaufler wrote:
>   
>> David P. Quigley wrote:
>>     
>>> This patch adds a setxattr handler to the file, directory, and symlink
>>> inode_operations structures for sysfs. This handler uses two new LSM hooks. The
>>> first hook takes the xattr name and value and turns the context into a secid.
>>> This is embedded into the sysfs_dirent structure so it remains persistent even
>>> if the inode structures are evicted from the cache. The second hook allows for
>>> the secid to be taken from the sysfs_dirent and be pushed into the inode
>>> structure as the actual secid for the inode.
>>>   
>>>       
>> Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
>>
>> I'm all for sysfs supporting xattrs.
>>
>> I am completely opposed to secids as file system metadata.
>>
>> What do you get when you do an ls -Z?
>>
>> An LSM must not be beholden to exposing transient internal
>> representations of security data to userspace, which is what
>> you're doing here. An LSM gets to decide what the security
>> information it maintains looks like by defining a security blob.
>>
>> If you want this in, implement xattrs in sysfs for real. Smack
>> depends on the existing, published, and supported xattr interfaces
>> for dealing with getting and setting the values. Not secids.
>> Smack maintains secids because labeled networking and audit require
>> them, and they got there first.
>>
>>
>>     
>
> So are you proposing that we embed a variable length string in the
> sysfs_dirent structure because that sounds completely silly. 

No, I'm not proposing that because it sounds silly, I'm proposing it
because that's the way xattrs work on Linux.

> It seems
> completely reasonable here to take the blob coming in and have the LSM
> turn it into a handle that is efficiently referenced by the
> sysfs_dirent. The problem here is that sysfs entries have no backing
> store at all which means everything we do will have to be added to
> sysfs_dirent. I'm pretty sure we don't want to be doing lifecycle
> management on strings inside this structure considering the only other
> string I see is marked const. If you have a better way of doing this I'm
> interested in hearing it but it doesn't seem reasonable to be storing
> the xattr itself in the sysfs_dirent.

Smack depends on the xattr interfaces to inspect and manipulate labels
on file system objects. Now you have a file system that "supports"
xattrs, but not the xattr interfaces. What if I want to change the
label on a sysfs entry? Or even read it? I can't with your scheme.

You are proposing a one-off hack to solve a particular problem. It
introduces issues of its own. I don't care that it is clever and
compact. It's not right.


>  I'd like to hear what Greg thinks
> about that.
>
> Dave
>
>
>   
