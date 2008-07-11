Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYGKIJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYGKIJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYGKIJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:09:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYGKIJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:09:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Subject: Re: [PATCH] ioctl conversion
Date: Fri, 11 Jul 2008 10:08:20 +0200
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <6d291e080807101728j62be7c93qba11aa214a8dfe1@mail.gmail.com>
In-Reply-To: <6d291e080807101728j62be7c93qba11aa214a8dfe1@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807111008.21497.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX191XkN9kZZs0eka55nUjsecjwNkairmnayItis
 oDLwMh6dBkHn9fVZ7BzPqukuBPN6Zeieu2r7YCPeq94MJMnGe9
 HEOMm4z7x4YLP0DyV3C7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008, Stoyan Gaydarov wrote:
> -       if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC)
> +       lock_kernel();
> +
> +       if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC) {
> +               unlock_kernel();
>                 return -ENOTTY;
> -       if (_IOC_NR(cmd) > SNAPSHOT_IOC_MAXNR)
> +       }
> +       if (_IOC_NR(cmd) > SNAPSHOT_IOC_MAXNR) {
> +               unlock_kernel();
>                 return -ENOTTY;
> -       if (!capable(CAP_SYS_ADMIN))
> +       }
> +       if (!capable(CAP_SYS_ADMIN)) {
> +               unlock_kernel();
>                 return -EPERM;
> +       }
> 
>         data = filp->private_data;

The more common way to express this is to end the function with

out:
	unlock_kernel();
	return ret;
}

and then jump to that label in the error case. This makes it
much easier to verify that you haven't missed a cased.

	Arnd <><
