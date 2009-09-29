Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZI2JXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZI2JXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZI2JXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:23:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:39172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZI2JXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:23:45 -0400
Date: Tue, 29 Sep 2009 11:24:10 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       jmorris@namei.org
Subject: Re: [PATCH 7/9] Simplify bound checks in capabilities for 
 copy_from_user
Message-ID: <20090929112410.0adc17f6@infradead.org>
In-Reply-To: <21d7e9970909282255y6718b11cvadafae0e1648817c@mail.gmail.com>
References: <20090926204951.424e567e@infradead.org>
	<20090926205336.77bc5b21@infradead.org>
	<21d7e9970909282255y6718b11cvadafae0e1648817c@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 15:55:49 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Sun, Sep 27, 2009 at 4:53 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: [PATCH 7/9] Simplify bound checks in capabilities for
> > copy_from_user CC: James Morris <jmorris@namei.org>
> >
> > The capabilities syscall has a copy_from_user() call where gcc
> > currently cannot prove to itself that the copy is always within
> > bounds.
> >
> > This patch adds a very explicity bound check to prove to gcc that
> > this copy_from_user cannot overflow its destination buffer.
> >
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> >
> > diff --git a/kernel/capability.c b/kernel/capability.c
> > index 4e17041..204f11f 100644
> > --- a/kernel/capability.c
> > +++ b/kernel/capability.c
> > @@ -238,7 +241,7 @@ SYSCALL_DEFINE2(capget, cap_user_header_t,
> > header, cap_user_data_t, dataptr) SYSCALL_DEFINE2(capset,
> > cap_user_header_t, header, const cap_user_data_t, data) {
> >        struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
> > -       unsigned i, tocopy;
> > +       unsigned i, tocopy, copybytes;
> >        kernel_cap_t inheritable, permitted, effective;
> >        struct cred *new;
> >        int ret;
> > @@ -255,8 +258,11 @@ SYSCALL_DEFINE2(capset, cap_user_header_t,
> > header, const cap_user_data_t, data) if (pid != 0 && pid !=
> > task_pid_vnr(current)) return -EPERM;
> >
> > -       if (copy_from_user(&kdata, data,
> > -                          tocopy * sizeof(struct
> > __user_cap_data_struct)))
> > +       copybytes = tocopy * sizeof(struct __user_cap_data_struct);
> > +       if (copybytes > _KERNEL_CAPABILITY_U32S)
> > +               return -EFAULT;
> 
> This is broken, it breaks dbus at least for me. you compare bytes
> to u32s wrongly.
> 
> Dave.

good point

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 7/9] Simplify bound checks in capabilities for copy_from_user
CC: James Morris <jmorris@namei.org>

The capabilities syscall has a copy_from_user() call where gcc currently
cannot prove to itself that the copy is always within bounds.

This patch adds a very explicity bound check to prove to gcc that 
this copy_from_user cannot overflow its destination buffer.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/kernel/capability.c b/kernel/capability.c
index 4e17041..204f11f 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -238,7 +241,7 @@ SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
 SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
 {
 	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
-	unsigned i, tocopy;
+	unsigned i, tocopy, copybytes;
 	kernel_cap_t inheritable, permitted, effective;
 	struct cred *new;
 	int ret;
@@ -255,8 +258,11 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
 	if (pid != 0 && pid != task_pid_vnr(current))
 		return -EPERM;
 
-	if (copy_from_user(&kdata, data,
-			   tocopy * sizeof(struct __user_cap_data_struct)))
+	copybytes = tocopy * sizeof(struct __user_cap_data_struct);
+	if (copybytes > sizeof(kdata))
+		return -EFAULT;
+
+	if (copy_from_user(&kdata, data, copybytes))
 		return -EFAULT;
 
 	for (i = 0; i < tocopy; i++) {



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
