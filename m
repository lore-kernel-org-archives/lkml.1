Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXI2Ph0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXI2Ph0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 11:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbXI2PhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 11:37:13 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:2318 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbXI2PhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 11:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LS5dWmgq2s5JnusxLfVXisNi+LMiyEuk8IkVZlgAEVI3ODYMkYspmv0DKeys0r1vQX0HoVCRjzpytQxmsWE0aIpRio6dievqFevQaJRnCtTDcTnh78C+/yTeZSBzNblPx6O/I8FLaVh+PHoPZdGUjXkOlzthZmAHhrMx9/FCo4M=
Message-ID: <961aa3350709290837m2d9d6668gd68b7cb8ac11e4d4@mail.gmail.com>
Date: Sun, 30 Sep 2007 00:37:10 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] module: return error when mod_sysfs_init() failed
Cc: linux-kernel@vger.kernel.org, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070929145646.GB3075@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070929100653.GA4121@APFDCB5C> <20070929145646.GB3075@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/29, Greg KH <gregkh@suse.de>:
> > Index: 2.6-git/kernel/module.c
> > ===================================================================
> > --- 2.6-git.orig/kernel/module.c
> > +++ 2.6-git/kernel/module.c
> > @@ -1782,7 +1782,8 @@ static struct module *load_module(void _
> >       module_unload_init(mod);
> >
> >       /* Initialize kobject, so we can reference it. */
> > -     if (mod_sysfs_init(mod) != 0)
> > +     err = mod_sysfs_init(mod);
> > +     if (err)
> >               goto cleanup;
>
> I must be still asleep this morning, but I think this patch does the
> exact same thing as the original code does, right?  Otherwise, this
> code would always be failing.
>
> Or do I just need to go get my morning coffee to wake up and see the
> problem here?

Hello,

In the original code, the "err" is zero before goto cleanup.
This "err" will be the return value of load_module().

load_module() is the function which returns error as pointer
and the expression IS_ERR(NULL) is false. So the caller of load_module()
cannot catch that error.

I found this problem when I was running the fault injection test
script in Documentation/fault-injection/fault-injection.txt with
random module.

#!/bin/bash

FAILTYPE=failslab
echo Y > /debug/$FAILTYPE/task-filter
echo 10 > /debug/$FAILTYPE/probability
echo 100 > /debug/$FAILTYPE/interval
echo -1 > /debug/$FAILTYPE/times
echo 0 > /debug/$FAILTYPE/space
echo 2 > /debug/$FAILTYPE/verbose
echo 0 > /debug/$FAILTYPE/ignore-gfp-wait

faulty_system()
{
        bash -c "echo 1 > /proc/self/make-it-fail && exec $*"
}

if [ $# -eq 0 ]
then
        echo "Usage: $0 modulename [ modulename ... ]"
        exit 1
fi

for m in $*
do
        echo inserting $m...
        faulty_system modprobe $m

        echo removing $m...
        faulty_system modprobe -r $m
done
