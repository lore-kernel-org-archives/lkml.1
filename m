Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZKRWpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZKRWpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZKRWpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:45:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47034 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbZKRWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:45:12 -0500
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
References: <m13a4pjjh9.fsf@fess.ebiederm.org>
	<200911082215.HGJ57827.SJOVFFOHMOLFQt@I-love.SAKURA.ne.jp>
	<m1bpjch9hy.fsf@fess.ebiederm.org>
	<200911090012.nA90CF2i016994@www262.sakura.ne.jp>
	<m1zl6j65by.fsf@fess.ebiederm.org>
	<200911190704.CHI18293.VJOMHFtOLQSOFF@I-love.SAKURA.ne.jp>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Nov 2009 14:45:13 -0800
In-Reply-To: <200911190704.CHI18293.VJOMHFtOLQSOFF@I-love.SAKURA.ne.jp> (Tetsuo Handa's message of "Thu\, 19 Nov 2009 07\:04\:19 +0900")
Message-ID: <m1k4xn8nba.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Hello.
>
> Eric W. Biederman wrote:
>> Tetsuo Handa writes:
>> 
>> > Eric W. Biederman wrote:
>> >> There has been a gradual transition from the assumption that the table ends with
>> >> !ctl_name to the assumption that procname == NULL.  There is no sysctl entry
>> >> with a valid ctl_name without a valid procname.
>> >
>> > I see. Then, please add below one to your patchset.
>> 
>> I have been looking at this and in the sysctl tree I am now going through
>> the vfs for all of the the operations on /proc/sys.  I believe that means
>> we can completely remove the sysctl special case in tomoyo.  Like I have
>> in the patch below.
>> 
>> Will that work?
>> 
>> Eric
>
> If you remove sysctl(2) from kernel and let userland libraries emulate
>
> 	static int name[] = { CTL_NET, NET_IPV4, NET_IPV4_LOCAL_PORT_RANGE };
> 	int buffer[2] = { 0, 0 };
> 	int size = sizeof(buffer);
> 	sysctl(name, 3, buffer, &size, 0, 0);
>
> like
>
> 	FILE *fp = fopen("/proc/sys/net/ipv4/ip_local_port_range", "r");
> 	int buffer[2] = { 0, 0 };
> 	fscanf(fp, "%u %u", &buffer[0], &buffer[1]);
> 	fclose(fp);
>
> or you modify sysctl(2) to call security_dentry_open() rather than
> security_sysctl(), we can completely remove the sysctl special case in tomoyo.

I have done something very close, the emulation is in the kernel not
user space, but the idea is the same.

The relevant bits of binary_sysctl() (from my sysctl tree) are:
	mnt = current->nsproxy->pid_ns->proc_mnt;
	result = vfs_path_lookup(mnt->mnt_root, mnt, pathname, 0, &nd);
	if (result)
		goto out_putname;

	result = may_open(&nd.path, acc_mode, fmode);
	if (result)
		goto out_putpath;

	file = dentry_open(nd.path.dentry, nd.path.mnt, flags, current_cred());
	result = PTR_ERR(file);
	if (IS_ERR(file))
		goto out_putname;

 dentry_open calls __dentry_open which calls security_dentry_open.

The twist that may get this into trouble is that I am going through
the internal vfs mount of /proc instead of the normal mount of proc.
So you will see paths like "/sys/net/ipv4/ip_local_port_range" instead
of "/proc/sys/net/ipv4/ip_local_port_range".  I don't know how the
choice of mount points affects you.

Eric
