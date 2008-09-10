Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYIJW5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYIJW5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYIJW5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:57:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1986 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYIJW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:57:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=jX7SEMYVtNxG1b6cbmC5a0fQUF+l4eQahfZoGxiDO15caxlgVP5pzDWh5q1q6l7Nc
	uyP0XZfyw8TMHyM4CUO3Q==
Message-ID: <166fe7950809101556q61cb7e30m2d5e758304618f61@mail.gmail.com>
Date: Wed, 10 Sep 2008 15:56:55 -0700
From: "Ranjit Manomohan" <ranjitm@google.com>
To: "Thomas Graf" <tgraf@suug.ch>
Subject: Re: [PATCH 1/2] Traffic control cgroups subsystem
Cc: davem@davemloft.net, akpm@linux-foundation.org, kaber@trash.net,
       lizf@cn.fujitsu.com, menage@google.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20080910220115.GH20815@postel.suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809101040280.7050@ranjit.corp.google.com>
	 <20080910220115.GH20815@postel.suug.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 3:01 PM, Thomas Graf <tgraf@suug.ch> wrote:
> * Ranjit Manomohan <ranjitm@google.com> 2008-09-10 10:42
>> +void cgroup_tc_set_sock_classid(struct sock *sk)
>> +{
>> +     if (sk)
>> +             sk->sk_cgroup_classid = cgroup_tc_classid(current);
>> +}
>> +
>> @@ -1170,6 +1171,8 @@ static int __sock_create(struct net *net, int family, int type, int protocol,
>>       if (err < 0)
>>               goto out_module_put;
>>
>> +     cgroup_tc_set_sock_classid(sock->sk);
>> +
>>       /*
>>        * Now to bump the refcnt of the [loadable] module that owns this
>>        * socket at sock_release time we decrement its refcnt.
>> @@ -1444,6 +1447,8 @@ asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
>>       if (err < 0)
>>               goto out_fd;
>>
>> +     cgroup_tc_set_sock_classid(newsock->sk);
>> +
>>       if (upeer_sockaddr) {
>>               if (newsock->ops->getname(newsock, (struct sockaddr *)address,
>>                                         &len, 2) < 0) {
>
> The big disadvantage of this method is that it does not allow to change
> the classid for sockets which already exist. It inherits the classid
> at socket creation time and then sticks to it. So if you want to follow
> this approach I'd suggest to at least store a reference to the cgroup
> state and reference count it properly.
>

I had considered adding support for moving tasks between cgroups by
going through all the open fds of the task and updating the sockets
(in the cgroup attach method). It is a very heavy weight operation and
not considered a common use case (and even undesirable at times) so I
dropped the idea. I can add it back in if it is considered essential.


> As for the locking that you mentioned in the other thread. IMHO it is
> not possible to lookup a socket without taking at least one lock, but
> I might be wrong there. Actually I think it will take even more locks
> as different locks are used to f.e. protect listening and established
> tcp sockets.

That is correct for ingress, for egress the sk is already available in
the skb so should be fine.

-Thanks,
Ranjit

>
