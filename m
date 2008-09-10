Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYIJG1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYIJG1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYIJG0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:26:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62722 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbYIJG0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:26:53 -0400
Message-ID: <48C76875.50007@cn.fujitsu.com>
Date: Wed, 10 Sep 2008 14:25:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Paul Menage <menage@google.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit]
 and find_css_set
References: <48AA684B.7000704@cn.fujitsu.com> <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com> <48C72E7C.8080302@cn.fujitsu.com> <20080910050112.GA2897@kroah.com> <6599ad830809092231h90712a6mc95b81229d64d6bc@mail.gmail.com> <20080910061717.GA6301@kroah.com>
In-Reply-To: <20080910061717.GA6301@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Sep 09, 2008 at 10:31:24PM -0700, Paul Menage wrote:
>> On Tue, Sep 9, 2008 at 10:01 PM, Greg KH <greg@kroah.com> wrote:
>>> What are you trying to solve here with this change?  I agree, it does
>>> seem a bit "chaotic" :)
>> There's a place in cgroups that uses kref_put() to release an object;
>> the release function *then* takes a write-lock and removes the object
>> from a lookup table; it could race with another thread that searches
>> the lookup table (while holding a read-lock) and does kref_get() on
>> the same object.
> 
> Ick, yeah that's not good.
> 
> What about the way everyone else solves this, grab the lock before you
> call kref_put()?
> 

do_exit()
  cgroup_exit()
    put_css_set_taskexit()
      kref_put()

If we grab the lock before kref_put(), we add overhead to do_exit(), which
is what we are trying to avoid here.

>> The current fix is for the release function to recheck inside the lock
>> that the object's refcount is still zero, and only actually
>> unlink/free it if so. And actually I've just realised that this isn't
>> actually even safe, since the thread that just acquired the object
>> could kref_put() it almost immediately, which would leave two threads
>> both trying to unlink/free the object.
> 
> Yeah, don't do that :)
> 
