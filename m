Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXE2DXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXE2DXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 23:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXE2DXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 23:23:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:23609 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbXE2DXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 23:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WeOcWaI5/hgua/p1RCU2saqSdgMlES1KxZ/DD9Zl6wqF/cesGjOZx4pKQ0GF/7A7GXS4KsPzdqGlTcbmym6cto8fx1vfEynhNJs9xW+WnKTzuunSXMs84Ar5xeATS5V51OAwdRyr+ysdYfa9ORCJPF7JCQgkFF9nbp58Na2Ls+w=
Message-ID: <787b0d920705282023v22316e6bk709dc8d3aa3213d7@mail.gmail.com>
Date: Mon, 28 May 2007 23:23:02 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel@vger.kernel.org, jengelh@linux01.gwdg.de, holt@sgi.com,
       ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt writes:
> On Apr 10 2007 17:47, Jan Engelhardt wrote:
>> On Apr 8 2007 20:57, Oleg Nesterov wrote:

>>> Anyway, re-parenting to swapper breaks pstree, it doesn't
>>> show kernel threads. And if ->parent == /sbin/init, we can't
>>> remove us from ->children (unless we forbid sub-thread-of-init
>>> exec). So the only safe change is set ->exit_state = -1.
>>
>> Then we have to fix pstree and all that. (In fact, I'm
>> trying to patch `ps f` to DTRT ;p)
>
> Done that and the result is that `ps afwx` now looks like:
>
>   PID TTY      STAT   TIME COMMAND
>  2722 ?        S      0:00 [lockd]
...
>     3 ?        S<     0:00 [events/0]
>     2 ?        SN     0:00 [ksoftirqd/0]
>     1 ?        Ss     0:02 init [3]
>   537 ?        S<s    0:02  \_ /sbin/udevd --daemon
>  1600 ?        Ss     0:00  \_ /usr/bin/dbus-daemon --system
>  1692 ?        Ss     0:00  \_ /sbin/acpid
>  1923 ?        Ss     0:00  \_ /sbin/resmgrd
...
> -    if(self_pid==1 && ADOPTED(processes[i]) && forest_type!='u')
> +    if(ADOPTED(processes[i]) && forest_type!='u')

That's not compatible because init's children are now in the
logical place. Since the days of procps-1.x.x or earlier,
such processes have been listed at top level.

BTW, what does "ps -ejH" do for you, with and without the patch?

I'd be a lot happier about breaking compatibility in this area
if I could get a functional adoption flag. That is, I really
would like to show a process as child of init if it naturally
was created as a child of init. It's less informative to have
fake children showing up the same as real ones. The original
parent PID would do. (BTW, the original parent name and/or
grandparent PID would be great to have) As a bonus, the kernel
could reap these processes more quickly than init can... and
then maybe we can stop caring if init is alive.
