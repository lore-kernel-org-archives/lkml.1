Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbZDUTuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbZDUTuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbZDUTt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:49:58 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:38669 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbZDUTt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:49:56 -0400
Cc: Christoph Hellwig <hch@infradead.org>,
       Suresh Jayaraman <sjayaraman@suse.de>,
       Masahiro Tamori <masahiro.tamori@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-nfs@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       LKML <linux-kernel@vger.kernel.org>, linux-embedded@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-Id: <1CCD753F-86BC-4C8D-96CC-FD3B67370B1F@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <1240335302.5390.20.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [ltt-dev] [PATCH] nfs: add support for splice writes
Date: Tue, 21 Apr 2009 14:48:14 -0400
References: <49D45974.2060202@suse.de> <20090402063235.GB24846@Krystal> <49D45E42.3050502@suse.de> <91e0b5050904020542l6b38d7a6hab6d7ef8b4593425@mail.gmail.com> <49EC0A83.8060802@suse.de> <1240230224.8073.6.camel@heimdal.trondhjem.org> <49EC6CB3.8080800@suse.de> <1240237274.13636.9.camel@heimdal.trondhjem.org> <49EC990B.1030007@suse.de>  <20090421144810.GA7036@infradead.org> <1240335302.5390.20.camel@heimdal.trondhjem.org>
X-Mailer: Apple Mail (2.930.3)
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.49EE233A.0239:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 21, 2009, at 1:35 PM, Trond Myklebust wrote:
> On Tue, 2009-04-21 at 10:48 -0400, Christoph Hellwig wrote:
>> On Mon, Apr 20, 2009 at 09:17:23PM +0530, Suresh Jayaraman wrote:
>>> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
>>> +				     struct file *filp, loff_t *ppos,
>>> +				     size_t count, unsigned int flags)
>>> +{
>>> +	struct dentry *dentry = filp->f_path.dentry;
>>> +
>>> +	dprintk("NFS splice_write(%s/%s, %lu@%Lu)\n",
>>> +		dentry->d_parent->d_name.name, dentry->d_name.name,
>>> +		(unsigned long) count, (unsigned long long) *ppos);
>>> +
>>> +	return generic_file_splice_write(pipe, filp, ppos, count, flags);
>>> +}
>>> +
>>
>> You need all calls from nfs_file_write, too:
>>
>> - most importantly the nfs_revalidate_file_size for O_APPEND
>
> Isn't O_APPEND illegal for splice_write()? It looks like it is from a
> quick perusal of do_splice_from().
>
>> - the nfs_do_fsync for sync writes
>
> generic_file_splice_write() calls generic_osync_inode(), which should
> ensure sync writes even with NFS.
> The one thing it won't do is propagate NFS write errors back to the
> caller. If we do care about this, then we should certainly test for
> nfs_need_sync_write() and then call nfs_do_fsync() (see
> nfs_file_write()).
>
>> - probably the stats increment
>
> We should talk to Chuck about this.

I don't know much about the characteristics of splice writes, so you  
can do one of two things:

1.  Create a separate BYTESWRITTEN counter for these
2.  Lump them into NORMALBYTESWRITTEN if these are effectively cached  
writes.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
