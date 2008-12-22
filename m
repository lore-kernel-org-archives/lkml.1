Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbYLVLFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbYLVLFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYLVLFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:05:34 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:3973 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbYLVLFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:05:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dtzNYYGzvGlWmPqR1KROwoyMQ1CvjiylepDl7KBs6Pd5XOpHWkkPfwd9uka9aIcMCO
         hdoQpCDIVJPUkis9iwpJSaflh53tbPhTBMkm+soSwczxtlk1G/QE9mw9U21KqWxftXRn
         oVmZY3TaaYou7GlyPmlhnvgXZxh/oYq1RP8vI=
Message-ID: <36ca99e90812220305p1ed3d5aehe46025eb8fae6158@mail.gmail.com>
Date: Mon, 22 Dec 2008 12:05:31 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Sebastian Andrzej Siewior" <sebastian@breakpoint.cc>
Subject: Re: [PATCH v2] add man-page for pthread_mutexattr_setrobust_np()
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20081222103953.GB15345@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081201213458.GA18973@Chamillionaire.breakpoint.cc>
	 <cfd18e0f0812070844t349b6026n6e2b0a2b4826fa66@mail.gmail.com>
	 <20081221205941.GA11805@Chamillionaire.breakpoint.cc>
	 <36ca99e90812212332l3067e911v89de96638734ea38@mail.gmail.com>
	 <20081222103953.GB15345@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +static int create_new_lock(void)
>>> +{
>>> +    int fd;
>>> +    pthread_mutex_t cmutex = PTHREAD_MUTEX_INITIALIZER;
>>> +    pthread_mutexattr_t attr;
>>> +    int ret;
>>> +
>>> +    pthread_mutexattr_init(&attr);
>>> +    pthread_mutexattr_setrobust_np(&attr, PTHREAD_MUTEX_ROBUST_NP);
>>> +    pthread_mutex_init(&cmutex, &attr);
>>> +
>>> +    fd = open(lock_name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR |
>>> +            S_IRGRP | S_IWGRP);
>>> +    if (fd < 0)
>>> +        return fd;
>>> +
>>> +    ret = write(fd, &cmutex, sizeof(cmutex));
>>I think its undefined behavior if you copy a struct pthread_mutex. You
>>should use mmap here too.
> Why should be this undefined? Is there something special about this
> struct? And why should this behave different with mmap() ?
If you would use mmap, you would initialize the mutex inside the
mmaped area, i.e. directly in the file.

To the copying:

Short answer: http://www.lambdacs.com/cpt/FAQ.html#Q15

Slightly longer:

pthread_mutex_t m1, m2;
pthread_mutex_init(&m1, NULL);
pthread_mutex_lock(&m1);
m2 = m1;
pthread_mutex_unlock(&m2);

How can you be sure, that you have unlocked m1 here?

Yes, you throw away the cmutex after returning from the function and
the copy inside the file is the only one left. I still think such code
should not be in a documentation.

Bert
>
> Sebastian
>
