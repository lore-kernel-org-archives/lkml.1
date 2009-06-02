Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZFBFQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZFBFQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZFBFQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:16:45 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45920 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZFBFQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BBR3YkAHEQcFR578Vn9kd2lMS+8mnJhrj+D+oQUkY4gJiKStUErxW9ZPW3kyWxJb1O
         bdok5vDQUXGzKWWeEraOVpNlhj1TOT05WQ5vRlCEBbt8g6hr5YW87RGiElZgz53HQirN
         8GFvewqd6H8sUhg+tuuabYP8+5oFcKr5TgZ/c=
MIME-Version: 1.0
In-Reply-To: <1243893048-17031-4-git-send-email-ebiederm@xmission.com>
References: <m1oct739xu.fsf@fess.ebiederm.org>
	 <1243893048-17031-4-git-send-email-ebiederm@xmission.com>
Date: Tue, 2 Jun 2009 08:16:44 +0300
X-Google-Sender-Auth: f737c126c5d8589e
Message-ID: <84144f020906012216n715a04d0ha492abc12175816@mail.gmail.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Tue, Jun 2, 2009 at 12:50 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> +#ifdef CONFIG_FILE_HOTPLUG
> +
> +static bool file_in_use(struct file *file)
> +{
> +       struct task_struct *leader, *task;
> +       bool in_use = false;
> +       int i;
> +
> +       rcu_read_lock();
> +       do_each_thread(leader, task) {
> +               for (i = 0; i < MAX_FILE_HOTPLUG_LOCK_DEPTH; i++) {
> +                       if (task->file_hotplug_lock[i] == file) {
> +                               in_use = true;
> +                               goto found;
> +                       }
> +               }
> +       } while_each_thread(leader, task);
> +found:
> +       rcu_read_unlock();
> +       return in_use;
> +}

This seems rather heavy-weight. If we're going to use this
infrastructure for forced unmount, I think this will be a problem.

Can't we two this in two stages: (1) mark a bit that forces
file_hotplug_read_trylock to always fail and (2) block until the last
remaining in-kernel file_hotplug_read_unlock() has executed?

                        Pekka
