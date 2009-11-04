Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbZKDVSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbZKDVSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbZKDVSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:18:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:23401 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589AbZKDVSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:18:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=lH49kKt6tXBq6Ey575jg8Z4+2fvYwoSMTL0B/fqaUYlDZmmqb9kDo/nRIfxrSSxuC
	cvqbX2/KOeoLei4Jqi9+g==
MIME-Version: 1.0
In-Reply-To: <20091104203024.GA14471@andrew.cmu.edu>
References: <20091102212825.GA13692@andrew.cmu.edu>
	 <20091102213022.GC13692@andrew.cmu.edu>
	 <20091104203024.GA14471@andrew.cmu.edu>
Date: Wed, 4 Nov 2009 13:18:34 -0800
Message-ID: <6599ad830911041318n3a07ef3dgd18dac00c772eeaf@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] cgroups: subsystem module interface
From: Paul Menage <menage@google.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       lizf@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com
Cc: bblum@andrew.cmu.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 12:30 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
>> +     init_cgroup_css(css, ss, dummytop);
>> +     init_css_set.subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
>
> There is a problem here; namely, the init_css_set is supposed to be
> immutable after boot. Putting a new subsystem state in it seems like it
> will be impossible to get right, since a hierarchy might be mounted and
> already using the init_css_set. Perhaps it would be better to use
> find_css_set for this?

Hmm, it's not just init_css_set that needs to get a pointer to the new
css, it's all existing css_sets - since every task has to start off in
the root cgroup for the new subsystem. A css_set is just a flattened
cache of the css pointers from all the cgroups that a task is a member
of, so when we add a css pointer to the unmount cgroup, we need to
either update all css_set objects, or else run through every task in
the system and update its cgroups pointer to a new css_set that's
equivalent to its old css_set plus the new css pointer.

Given the races inherent in trying to find and update all tasks in the
system, I think the cleanest way to solve this is:

- copy the css_set_table hash table and clear the original table.
- for each bucket in the hash table:
  - for each css_set in the bucket:
    - add the new root css to the css_set
    - rehash the css_set into the hash table

Unfortunately this issue also makes it a bit harder to support
modular-subsystem unloading.

Paul
