Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYIJPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYIJPDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYIJPD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:03:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYIJPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:03:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NqYF5PJpNmH1d/ugLfz7yjGCsmAhP6fOuKPaMipuhsMdUZxCrHIEn20L2T37tdx8D
	srZog3LP15LWw7OX8dtkQ==
Message-ID: <6599ad830809100803w1bbbb331qa6741b9f42204dcf@mail.gmail.com>
Date: Wed, 10 Sep 2008 08:03:18 -0700
From: "Paul Menage" <menage@google.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
Cc: "Li Zefan" <lizf@cn.fujitsu.com>, "Lai Jiangshan" <laijs@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080910062951.GA6779@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AA684B.7000704@cn.fujitsu.com>
	 <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com>
	 <48C72E7C.8080302@cn.fujitsu.com> <20080910050112.GA2897@kroah.com>
	 <6599ad830809092231h90712a6mc95b81229d64d6bc@mail.gmail.com>
	 <20080910061717.GA6301@kroah.com> <48C76875.50007@cn.fujitsu.com>
	 <20080910062951.GA6779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 11:29 PM, Greg KH <greg@kroah.com> wrote:
>
> But you can't put such logic in the release() function as you are
> finding out, that's not going to work either.

Right - that's why a kref_put_and_write_lock() function would be handy
- it would take the lock only when necessary. It would delegate most
of its work to the (as-yet nonexistant) atomic_dec_and_write_lock()
function, which would be an rwlock equivalent of atomic_dec_and_lock()

>
> Maybe you need to just "open-code" an atomic counter here and not use
> kref as it sounds like you are needing to do something very "special"
> here.
>

It's basically the same situation as the dentry cache - ref-counted
objects that are also referenced from a hash table protected by a
global lock.

If you're opposed to the addition of kref_put_and_write_lock() then
yes, I'll replace kref with a custom refcount.

Paul
