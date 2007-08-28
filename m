Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbXH1BiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbXH1BiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXH1BiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:38:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56407 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752302AbXH1BiA (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:38:00 -0400
Message-ID: <46D37C70.5070907@sgi.com>
Date: Tue, 28 Aug 2007 11:37:52 +1000
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Josef Sipek <jsipek@fsl.cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>
Subject: Re: [PATCH 2/4] Fix mainline filesystems to handle ATTR_KILL_ bits
 correctly
References: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com>	<46CA798C.1020101@sgi.com>	<20070821073551.dac4a5dd.jlayton@redhat.com>	<20070821212128.GC1741@filer.fsl.cs.sunysb.edu> <20070821182305.7c0cb135.jlayton@redhat.com>
In-Reply-To: <20070821182305.7c0cb135.jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:
> On Tue, 21 Aug 2007 17:21:28 -0400
> Josef Sipek <jsipek@fsl.cs.sunysb.edu> wrote:
> 
>> On Tue, Aug 21, 2007 at 07:35:51AM -0400, Jeff Layton wrote:
>>> On Tue, 21 Aug 2007 15:35:08 +1000
>>> Timothy Shimmin <tes@sgi.com> wrote:
>>>
>>>> Jeff Layton wrote:
>>>>> This should fix all of the filesystems in the mainline kernels to handle
>>>>> ATTR_KILL_SUID and ATTR_KILL_SGID correctly. For most of them, this is
>>>>> just a matter of making sure that they call generic_attrkill early in
>>>>> the setattr inode op.
>>>>>
>>>>> Signed-off-by: Jeff Layton <jlayton@redhat.com>
>>>>> ---
>>>>>  fs/xfs/linux-2.6/xfs_iops.c               |    5 ++++-
>>>>> --- a/fs/xfs/linux-2.6/xfs_iops.c
>>>>> +++ b/fs/xfs/linux-2.6/xfs_iops.c
>>>>> @@ -651,12 +651,15 @@ xfs_vn_setattr(
>>>>>  	struct iattr	*attr)
>>>>>  {
>>>>>  	struct inode	*inode = dentry->d_inode;
>>>>> -	unsigned int	ia_valid = attr->ia_valid;
>>>>> +	unsigned int	ia_valid;
>>>>>  	bhv_vnode_t	*vp = vn_from_inode(inode);
>>>>>  	bhv_vattr_t	vattr = { 0 };
>>>>>  	int		flags = 0;
>>>>>  	int		error;
>>>>>  
>>>>> +	generic_attrkill(inode->i_mode, attr);
>>>>> +	ia_valid = attr->ia_valid;
>>>>> +
>>>>>  	if (ia_valid & ATTR_UID) {
>>>>>  		vattr.va_mask |= XFS_AT_UID;
>>>>>  		vattr.va_uid = attr->ia_uid;
>>>> Looks reasonable to me for XFS.
>>>> Acked-by: Tim Shimmin <tes@sgi.com>
>>>>
>>>> So before, this clearing would happen directly in notify_change()
>>>> and now this won't happen until notify_change() calls i_op->setattr
>>>> which for a particular fs it can call generic_attrkill() to do it.
>>>> So I guess for the cases where i_op->setattr is called outside of
>>>> via notify_change, we don't normally have ATTR_KILL_SUID/SGID
>>>> set so that nothing will happen there?
>>> Right. If neither ATTR_KILL bit is set then generic_attrkill is a
>>> noop.
>>>
>>>> I guess just wondering the effect with having the code on all
>>>> setattr's. (I'm not familiar with the code path)
>>>>
>>> These bits are referenced in very few places in the current kernel
>>> tree -- mostly in the VFS layer. The *only* place I see that they
>>> actually get interpreted into a mode change is in notify_change. So
>>> places that call setattr ops w/o going through notify_change are
>>> not likely to have those bits set.
>>>
>>> But hypothetically, if a fs did set ATTR_KILL_* and call setattr
>>> directly, then the setattr would now include a mode change that
>>> clears setuid or setgid bits where it may not have before.
> 
> I should probably clarify -- in the hypothetical situation above,
> the setattr function would have to call generic_attrkill (as most
> filesystems should do with this change).
> 
Thanks for the confirmation. That's what it looked like to me
but I wanted to know explicitly what the thinking was.

>> It almost sounds like an argument for a new inode op (NULL would use
>> generic_attr_kill).
>>
> 
> That's not a bad idea at all. I suppose that would be easier than
> modifying every fs like this, and it does seem like it might be
> cleaner. I need to mull it over, but that might be the best
> solution.
> 
Yeah, sounds a much more direct way of handling things and as you
say wouldn't need most of the filesystems to all be modified calling
generic_attrkill.
Not sure what the ramifications of adding a new iop are though.

Cheers,
Tim.
