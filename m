Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZLVQQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZLVQQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZLVQQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:16:14 -0500
Received: from smtp2b.orange.fr ([80.12.242.146]:25417 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZLVQQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:16:13 -0500
X-ME-UUID: 20091222161609551.868F48000112@mwinf2b26.orange.fr
X-ME-User-Auth: jean-pierre.andre
Message-ID: <4B30F0C9.2020702@wanadoo.fr>
Date: Tue, 22 Dec 2009 17:16:09 +0100
From: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4) Gecko/20091027 Fedora/2.0-7.fc13 SeaMonkey/2.0
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Eric Blake <ebb9@byu.net>, fuse-devel@lists.sourceforge.net,
       Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr> <87ljgvi1an.fsf@devron.myhome.or.jp>
In-Reply-To: <87ljgvi1an.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

OGAWA Hirofumi wrote:
> Jean-Pierre André<jean-pierre.andre@wanadoo.fr>  writes:
>
>    
>> Hi again,
>>      
> Hi,
>
>    
>>> Well, the problem seems in fuse_lib_setattr() and ntfs_fuse_setattr()
>>> (lowlevel op too).
>>>
>>> The both functions is requiring "ATIME | MTIME". Doesn't it mean the
>>> ntfs-3g can't set only MTIME like above utimensat()?
>>>
>>>        
>> With ntfs-3g this is not directly possible, because
>> the interface does not provide flags telling which
>> timestamps should be updated. The only way would
>> be fuse feeding both values (even though unchanged)
>> before calling ntfs-3g. This is true for all versions of
>> ntfs-3g.
>>      
> Yes, with fuse_operations. It is why I'm saying the issue is libfuse or
> ntfs-3g.
>
> But I noticed ntfs-3g is including libfuse-lite sources and use it with
> static link (I might be wrong here, because I just looked ntfs-3g source
> slightly). AFAIK, the fuse of kernel part is passing the flags of some
> sort of detail always.
>    

Use of fuse-lite is optional, and static linking also
(both depend on your configure options),

> [BTW, the code of that part in kernel may be the following,
>
> fs/fuse/dir.c:iattr_to_fattr(),
>
>    
[...]
> So, if libfuse-lite was fixed to supported that update request, it would
> be able to do even if fuse_operations.  I.e. in libfuse-lite, emulate
> "ATIME | MTIME" request if "MTIME" only (pass unchanged original atime),
> then call ->utime() callback. (or adds new utime2 callback with flags, or
> something other solutions)
>    

I will port to fuse-lite the patch which Miklos has
just sent.

> Or, if that request is known limitation of fuse_operations, I think it
> would be clear state and ok. The fs needs to use lowlevel op to support
> that.
>
>    
>> With lowntfs-3g (release candidate only), this could
>> be possible.... but this is not implemented, as the
>> case was never found up to now. I can provide you
>> with a patch,... if fuse can feed in the flags selectively.
>>      
> Yes.  AFAIK, fuse of kernel part is passing FATTR_MTIME without
> FATTR_ATIME to userland (i.e. FUSE_SET_ATTR_ATIME and
> FUSE_SET_ATTR_MTIME in libfuse).
>
> I think it's good to implement if it's not design decision of ntfs-3g.
>
> [BTW, just my guess though, it would be good to use "if (vaild&
> ATTR_XXX)" style, not "switch()" to support various combinations of
> flags]
>    

Might be better, ... or not. Setting both mtime
and atime is much simpler than setting each one
individually. So both methods will end up having
to process three different situations.

I suggest I port Miklos patch to fuse-lite soon,
and delay the low-level case (and microsecond
precision) until January. Does that suit your needs ?

Also : there is a common case of mis-configuration
in which gid is set in the mount options and uid
is not. As a consequence files appear as owned
by root and utime() is forbidden to plain users.

So you should first check your mount options.
And since ntfs-2009.11.14 standard ownership
and permissions are fully supported provided a
proper configuration file has been set.

Regards

Jean-Pierre



> Thanks.
>    

-- 
JP André
email jean-pierre.andre@wanadoo.fr




