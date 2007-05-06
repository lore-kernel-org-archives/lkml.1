Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXEFA1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXEFA1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 20:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbXEFA1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 20:27:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:49719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXEFA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 20:27:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
Date: Sun, 6 May 2007 02:27:28 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1178215277.4369.6.camel@amdx2.microgate.com> <200705051258.01743.arnd@arndb.de> <463C8D42.7020707@microgate.com>
In-Reply-To: <463C8D42.7020707@microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-1?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-1?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ?=
 =?iso-8859-1?q?=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-1?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-1?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705060227.29450.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19VG1Rl5X3aZ5+yNF0o61T0KoiR1PvoJIQfEr9
 FDWXCYyTKApjarB5pqye5eu+CynDUd6i2JC+zUQXrJywOd0Vb3
 Jqd88425UCFp7bqgxU2lw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2007, Paul Fulghum wrote:

> That declaration will need to be duplicated in each driver that
> uses it (4 drivers in my case). In that sense (a structure declaration
> used by multiple code modules) it does seem like an interface definition.
> 
> If that is what is needed, I will do it.

Now that you mention the duplication, this sounds wrong as well. The easiest
solution is probably to just put the definition of your data structure
inside of #ifdef CONFIG_COMPAT in the header file.

Or you could go really fancy and write a new file that does the synclink
compat_ioctl handling in a generic way end in the end just calls the
fops->{unlocked_,}ioctl() function.

Which reminds me that I have been meaning to do a patch that creates
a new generic_compat_ioctl() [1] function for some time, and convert
drivers to this if their handlers are all compatible.

	Arnd <><

[1]
/*
 * Can be used as the ->compat_ioctl method in the file_operations
 * for any driver that does not need any conversion in its ioctl
 * handler
 */
long generic_file_compat_ioctl(struct file *file, unsigned int cmd,
				unsigned long arg)
{
	int ret;
	arg = (unsigned long)compat_ptr(arg);

	if (file->f_ops->unlocked_ioctl)
		ret = file->f_ops->unlocked_ioctl(file, cmd, arg);
	else {
		lock_kernel();
		ret = file->f_ops->ioctl(file, cmd, arg);
		unlock_kernel();
	} else
		ret = -ENOIOCTLCMD;

	return ret;
}
