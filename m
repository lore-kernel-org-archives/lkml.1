Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980Ab0AHK7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0AHK7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826Ab0AHK7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:59:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0AHK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:59:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 3/3] generic sys_ipc wrapper
Date: Fri, 8 Jan 2010 11:57:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00053-g43eb7c4-dirty; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
References: <20100106172152.GC17163@lst.de> <20100108095023.GA29560@lst.de> <20100108100347.GA30353@lst.de>
In-Reply-To: <20100108100347.GA30353@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001081157.17195.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1//qohNSM8J/tnlT9SNw3cjfrinlBh0CtZ6aOy
 O4qAkCEGP/9iHqgG1kueDukFABneG0gmQzdjnw79cxbTPhMgs9
 U2IGrKuDoMptm01HoC9og==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 January 2010 11:03:47 Christoph Hellwig wrote:
> On Fri, Jan 08, 2010 at 10:50:23AM +0100, Christoph Hellwig wrote:
> > Always return -EINVAL for the iBCS2 special case in SHMAT, and add a
> > prototype to linux/syscalls.h

ok, the changes look good.

> Add a generic implementation of the ipc demultiplexer syscall.  Except for
> s390 and sparc64 all implementations of the sys_ipc are nearly identical.

I think the s390 version is trivial to add as well, like

SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
 		unsigned long, third, void __user *, ptr)
{
	if (call == SEMTIMEDOP)
		return sys_semtimedop(first, (struct sembuf __user *)ptr,
				      (unsigned) second,
				      (const struct timespec __user *)third);

	return sys_ipc(call & 0xffff, first, second, third, ptr, 0);
}

But while going over the code again, I noticed that you broke sign extension
at least on powerpc and s390, possibly on all 64 bit machines:

> +SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, int, second,
> +		unsigned long, third, void __user *, ptr, long, fifth)
> +{
> +	int version, ret;
> +
> +	version = call >> 16; /* hack for backward compatibility */
> +	call &= 0xffff;
> +
> +	switch (call) {
> +	case SEMOP:
> +		return sys_semtimedop(first, (struct sembuf __user *)ptr,
> +				      second, NULL);

                                       (unsigned)second, NULL

> +	case SEMTIMEDOP:
> +		return sys_semtimedop(first, (struct sembuf __user *)ptr,
> +				      second,

                                      (unsigned)second,

> +				      (const struct timespec __user *)fifth);
> +
> +	case SEMGET:
> +		return sys_semget(first, second, third);

                                         (int)second,

> +	case SEMCTL: {
> +		union semun fourth;
> +		if (!ptr)
> +			return -EINVAL;
> +		if (get_user(fourth.__pad, (void __user * __user *) ptr))
> +			return -EFAULT;
> +		return sys_semctl(first, second, third, fourth);

		return sys_semctl(first, (int)second, third, fourth);

> +	case MSGSND:
> +		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
> +				  second, third);

				  (size_t)second, third);

> +	case MSGRCV:
> +		switch (version) {
> +		case 0: {
> +			struct ipc_kludge tmp;
> +			if (!ptr)
> +				return -EINVAL;
> +
> +			if (copy_from_user(&tmp,
> +					   (struct ipc_kludge __user *) ptr,
> +					   sizeof(tmp)))
> +				return -EFAULT;
> +			return sys_msgrcv(first, tmp.msgp, second,

			return sys_msgrcv(first, tmp.msgp, (size_t)second,

> +					   tmp.msgtyp, third);
> +		}
> +		default:
> +			return sys_msgrcv(first,
> +					   (struct msgbuf __user *) ptr,
> +					   second, fifth, third);

					   (size_t)second, fifth, third);

> +		}
> +	case MSGGET:
> +		return sys_msgget((key_t) first, second);

		return sys_msgget((key_t) first, (int)second);

> +	case MSGCTL:
> +		return sys_msgctl(first, second, (struct msqid_ds __user *)ptr);

		return sys_msgctl(first, (int)second, (struct msqid_ds __user *)ptr);

> +	case SHMAT:
> +		switch (version) {
> +		default: {
> +			unsigned long raddr;
> +			ret = do_shmat(first, (char __user *)ptr,
> +				       second, &raddr);

				       (int)second, &raddr);

> +			if (ret)
> +				return ret;
> +			return put_user(raddr, (unsigned long __user *) third);
> +		}
> +		case 1:
> +			/*
> +			 * This was the entry point for kernel-originating calls
> +			 * from iBCS2 in 2.2 days.
> +			 */
> +			return -EINVAL;
> +		}
> +	case SHMDT:
> +		return sys_shmdt((char __user *)ptr);
> +	case SHMGET:
> +		return sys_shmget(first, second, third);

				       (size_t)second, &raddr);

> +	case SHMCTL:
> +		return sys_shmctl(first, second,

		return sys_shmctl(first, (int)second,

> +				   (struct shmid_ds __user *) ptr);
> +	default:
> +		return -ENOSYS;
> +	}
> +}

This is needed to make sure the upper half of the register is filled with
zero-extended or sign-extended correctly and does not contain random garbage
in the native 64 bit case. IIRC, x86_64 does not have this problem and mips64
may have the wrong code already. Alpha, parisc and ia64 don't have a native
sys_ipc and the rest are 32 bit, so they don't care.

	Arnd
