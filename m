Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbZCYP11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbZCYP11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbZCYP1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:27:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbZCYP1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:27:17 -0400
Date: Wed, 25 Mar 2009 11:27:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Hua Zhong <hzhong@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
In-Reply-To: <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903251120000.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org>  <20090325052023.071564146@goodmis.org>  <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>  <009101c9ad20$1ae231c0$50a69540$@com>  <1237968394.30175.12.camel@penberg-laptop>
 <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com> <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Steven Rostedt wrote:
> 
>  # cat /debug/tracing/trace | sort -u
> 
> record_nulls: ptr=(null) (ext3_get_acl+0x1e0/0x3f0 [ext3])
> record_nulls: ptr=(null) (free_bitmap+0x29/0x70)
> record_nulls: ptr=(null) (free_tty_struct+0x1d/0x40)
> record_nulls: ptr=(null) (ftrace_graph_exit_task+0x1e/0x20)
> record_nulls: ptr=(null) (inet_sock_destruct+0x1cb/0x2a0)
> record_nulls: ptr=(null) (ip_cork_release+0x24/0x50)
> record_nulls: ptr=(null) (keyctl_join_session_keyring+0x5a/0x70)
> record_nulls: ptr=(null) (key_user_lookup+0x183/0x220)
> record_nulls: ptr=(null) (kobject_set_name_vargs+0x43/0x50)
> record_nulls: ptr=(null) (netlink_release+0x1a4/0x2f0)
> record_nulls: ptr=(null) (release_sysfs_dirent+0x20/0xc0)
> record_nulls: ptr=(null) (sysfs_open_file+0x1c8/0x3e0)
> record_nulls: ptr=(null) (tty_write+0x16a/0x290)
> 

Hmm, it is looking like the patter of calling kfree(NULL) is due to this:

struct some_struct *some_init_function(int some_option)
{
	some_pointer = kzalloc(sizeof(struct some_struct));

	if (some_option)
		some_pointer->some_item = kmalloc();

	return some_pointer;
}

some_destructor(struct some_struct *some_pointer)
{
	kfree(some_pointer->some_item);
	kfree(some_pointer);
}

That is, a structure may or may not allocate memory for various items in 
the structure. They may stay as NULL. On the destructor side, instead of 
testing if the items are NULL, we simply call kfree on them.

This explains why the object is not unlikely to be NULL in kfree.

Note, likely is not the same as majority of the time. If I were to say, 7% 
of the next 100 days will snow. Can you say it is unlikely that it will 
snow? Perhaps on a certain day it may be unlikely, but it is very likely 
it will eventually snow. The same should go with the macros. If you say, 
unlikely, it really should mean, I do not expect this to ever happen. 
Not, the majority of the times it will not happen.

-- Steve

