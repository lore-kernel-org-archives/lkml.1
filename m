Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbYIJA2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbYIJA2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYIJA2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:28:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5787 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYIJA2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:28:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YARr0N8Y2r3klNjp/8KrlE5QiyEvOQ8OYTJpps5iYgJErzq8v5GN0LXOz9uJEfl14
	vqeqjmMH4GpdYfK57jIpQ==
Message-ID: <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com>
Date: Tue, 9 Sep 2008 17:28:03 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48AA684B.7000704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AA684B.7000704@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 11:29 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> put_css_set_taskexit may be called when find_css_set is called on
> other cpu. And the race will occur:
>


Sorry I didn't respond to this when it originally came out - I was on vacation.

I agree that it's a race that needs to be fixed, but I'm not sure that
I like the fix that can generate kref warnings.

I can see two possible fixes:

1) avoid the race entirely by introducing some new primitives:

atomic_dec_and_write_lock() (like atomic_dec_and_lock(), but for an rwlock)

and kref_put_and_write_lock() which would be something like:

int kref_put_and_write_lock(struct kref *kref, void (*release)(struct
kref *kref), rwlock*lock)
{
  if(atomic_dec_and_write_lock(&kref->refcount, lock)) {
    release(kref);
    return 1;
  }
  return 0;
}

We'd then use kref_put_and_write_lock(), and enter __release_css_set()
with the lock already held

2) Use atomic_inc_not_zero() in find_existing_css_set(), to ensure
that we only return a referenced css, and remove the get_css_set()
call from find_css_set(). (Possibly wrapping this in a new
kref_get_not_zero() function)

Paul
