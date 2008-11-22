Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYKVIDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYKVIDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 03:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYKVICw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 03:02:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:55468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYKVICv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 03:02:51 -0500
Message-ID: <4927BC9A.3000001@kernel.org>
Date: Sat, 22 Nov 2008 17:02:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, greg@kroah.com
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in Userspace
References: <1227190983-5820-1-git-send-email-tj@kernel.org>	<1227190983-5820-6-git-send-email-tj@kernel.org> <20081121211607.49e0ec84.akpm@linux-foundation.org>
In-Reply-To: <20081121211607.49e0ec84.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 22 Nov 2008 08:02:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> The only notable lacking feature compared to in-kernel implementation
>> is mmap support.
>>
>> ...
>>
>> +struct cuse_conn {
>> +	struct fuse_conn	fc;
>> +	struct cdev		cdev;
>> +	struct vfsmount		*mnt;
>> +	struct device		*dev;
>> +
>> +	/* init parameters */
>> +	bool			unrestricted_ioctl:1;
> 
> I'd suggest removal of the :1 here.  If someone later comes along and
> adds another bitfield next to it, locking will be needed to prevent
> racess accessing the bitfields, and I seeno appropriate lock here, nor
> any comment explaining the locking..

/* init parameters */ pretty much indicates that they're set once during
initialization (no locking concerns).  Anyways, at this point, it
doesn't matter anyway, I'll drop the :1.

>> +static int cuse_init_worker(void *data)
>> +{
>> +	struct cuse_init_in iin = { };
>> +	struct cuse_init_out iout = { };
>> +	struct cuse_devinfo devinfo = { };
> 
> You might want to check the generated code here.  gcc has a habit of
> assembling a temp structure on the stack then memcpying it over, which
> is just junk.  This will be gcc version dependent.  Fixable by using an
> old-fashioned memset instead.

My gcc-4.3.1 20080507 does four movq's to initialize iin and iout on
stack during function preamble and one movq for devinfo later in the
function body.

At any rate, this code path is run only once per CUSE device
initialization and those structures are small enough to be on stack.  I
would go for simpler code anyday here.

Thanks.

-- 
tejun
