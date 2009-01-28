Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZA1EHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZA1EHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZA1EHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:07:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:60944 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZA1EHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:07:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XsEw9aZZzZq8VoEwXC1WoM13jn/8soJMyessmCQO9pfTLqPBzOLUpTZsbZLrFUUW9u
         ZohmZi4LW7h8/lqBLJEYipPircZx4Lx5v3NmBIir6vRa6aRvTL/DoWvCyl9kzKPSWaUn
         GvB7XFNkQHWqESzLBfmdldxXK1Dt+ZYuLTDtw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
References: <20090128033824.GA1662@brong.net>
	 <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
	 <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
Date: Tue, 27 Jan 2009 20:07:32 -0800
X-Google-Sender-Auth: 0b78b3b7aa5aa031
Message-ID: <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
From: Ray Lee <ray-lk@madrabbit.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 8:00 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Wed, 28 Jan 2009, Bron Gondwana wrote:
>
>> Both Postfix and Apache use an epoll instance per child, which
>> leads to significant scalability issues with max_user_instances
>> set so low.  Bump the default to 1024 so medium sized sites are
>> not impacted.
>
> NACK. Epoll allocates globally about 100 to 160 bytes (32/64 bit) for each
> file added to the interface:
>
>        for i 1..1024
>                for j 1..1024
>                        if i!=j
>                                add j -> i
>
> That's (N^2 * {100, 160}) = 100MB to 160MB of pinned kernel memory,
> explotable by simple users with untouched NFILES.
> This is the reason such limit was introduced in the first place. Again,
> for the 10th time, if you have a loaded server with multiple processes
> using epoll:
>
> $ echo NN > /proc/sys/fs/epoll/max_user_instances
>
> Note that NN does not consume any resource "per se", so if you feel
> threatened by such limit, you can go wild with it.

It's really simple. A kernel upgrade in a -stable series point release
broke a rational user-space setup. If you don't want to adjust the
defaults, then the sane thing to do is to revert the commit that
caused the grief. Postfix is everywhere. Apache is everywhere.

Userspace is not broken here, and the whole idea of a -stable series
is that administrators can upgrade to them without having to worry
about things getting broken or making specific configuration changes
by point release.
