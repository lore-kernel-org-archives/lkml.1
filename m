Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZKKCev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZKKCev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbZKKCeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:34:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55661 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbZKKCet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:34:49 -0500
Message-ID: <4AFA2293.5080803@cn.fujitsu.com>
Date: Wed, 11 Nov 2009 10:33:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
References: <20091025225342.007138f5@infradead.org>
In-Reply-To: <20091025225342.007138f5@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Tracepoint for dirtying an inode:
> + */
> +TRACE_EVENT(dirty_inode,
> +
> +	TP_PROTO(struct inode *inode, struct task_struct *task),
> +
> +	TP_ARGS(inode, task),
> +
> +	TP_STRUCT__entry(
> +		__array( char,	comm,	TASK_COMM_LEN	)
> +		__field( pid_t,	pid			)
> +		__array( char,  dev,    16		)
> +		__array( char,  file,   32		)
> +	),
> +
> +	TP_fast_assign(
> +		if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
> +                	struct dentry *dentry;
> +                	const char *name = "?";
> +
> +			dentry = d_find_alias(inode);
> +			if (dentry) {
> +				spin_lock(&dentry->d_lock);
> +				name = (const char *) dentry->d_name.name;
> +			}
> +
> +			memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +			__entry->pid = task->pid;
> +			strlcpy(__entry->file, name, 32);
> +			strlcpy(__entry->dev, inode->i_sb->s_id, 16);
> +
> +			if (dentry) {
> +				spin_unlock(&dentry->d_lock);
> +				dput(dentry);
> +			}
> +		}

This will leave __entry->comm, __entry->file and __entry->dev
uninitialized in the "else" case..

And is there any reason that we have to use __array() but can't
use __string()?

> +	),
> +
> +	TP_printk("task=%i (%s) file=%s dev=%s",
> +		__entry->pid, __entry->comm, __entry->file, __entry->dev)
> +);
> +
> +#endif /* _TRACE_VFS_H */
