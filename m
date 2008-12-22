Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYLVKkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYLVKkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYLVKj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:39:56 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49831 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYLVKjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:39:55 -0500
Date: Mon, 22 Dec 2008 11:39:53 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] add man-page for pthread_mutexattr_setrobust_np()
Message-ID: <20081222103953.GB15345@Chamillionaire.breakpoint.cc>
References: <20081201213458.GA18973@Chamillionaire.breakpoint.cc> <cfd18e0f0812070844t349b6026n6e2b0a2b4826fa66@mail.gmail.com> <20081221205941.GA11805@Chamillionaire.breakpoint.cc> <36ca99e90812212332l3067e911v89de96638734ea38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <36ca99e90812212332l3067e911v89de96638734ea38@mail.gmail.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bert Wesarg | 2008-12-22 08:32:15 [+0100]:

>> +static int open_existing_lock(void)
>> +{
>> +    int fd;
>> +    int ret;
>> +    struct stat buf;
>> +    int retry = 5;
>> +
>> +    fd = open(lock_name, O_RDWR);
>> +    if (fd < 0)
>> +        return fd;
>> +    do {
>> +        ret = fstat(fd, &buf);
>> +        if (ret < 0)
>Isn't here a close(2) missing?
yes it is. Thx.

>> +            return ret;
>> +
>> +        if (buf.st_size == sizeof(*limi_mutex))
>> +            return fd;
>> +
>> +        close(fd);
>Isn't this close(2) wrong here?
uhhh. Actually I wanted to have the open() within the do while loop. So
I move that and this will be fine then.

>> +        sleep(1);
>> +        retry\-\-;
>> +    } while (retry);
>> +
>> +    close(fd);
>> +    return \-1;
>> +}
>> +
>> +static int create_new_lock(void)
>> +{
>> +    int fd;
>> +    pthread_mutex_t cmutex = PTHREAD_MUTEX_INITIALIZER;
>> +    pthread_mutexattr_t attr;
>> +    int ret;
>> +
>> +    pthread_mutexattr_init(&attr);
>> +    pthread_mutexattr_setrobust_np(&attr, PTHREAD_MUTEX_ROBUST_NP);
>> +    pthread_mutex_init(&cmutex, &attr);
>> +
>> +    fd = open(lock_name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR |
>> +            S_IRGRP | S_IWGRP);
>> +    if (fd < 0)
>> +        return fd;
>> +
>> +    ret = write(fd, &cmutex, sizeof(cmutex));
>I think its undefined behavior if you copy a struct pthread_mutex. You
>should use mmap here too.
Why should be this undefined? Is there something special about this
struct? And why should this behave different with mmap() ?

Sebastian
