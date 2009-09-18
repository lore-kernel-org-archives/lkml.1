Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZIRCUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZIRCUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZIRCUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:20:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:61714 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbZIRCUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:20:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JknK91HzFTGcMufhafbpJt2Fv3kwgEy1dRrK48x7SSPrlQAG0+cnhFwxInF0fwtWqU
         htdfdH8otc+slCKywExse95Gpk3w+FhSajsIS5RiFOVdoD0T0EM39JHWk4eh8IEde7t8
         uKRH9nkw4uvXRAuoUCr8SZZ9+wiWnbj0NJuU8=
MIME-Version: 1.0
In-Reply-To: <20090917151016.99f7c5ab.kamezawa.hiroyu@jp.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	 <1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	 <20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090917114404.d87b155d.kamezawa.hiroyu@jp.fujitsu.com>
	 <2375c9f90909162302m1fb89414o4f72b6b36e7cbb06@mail.gmail.com>
	 <20090917151016.99f7c5ab.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 18 Sep 2009 10:20:36 +0800
Message-ID: <2375c9f90909171920q6941b8al39a045529550732d@mail.gmail.com>
Subject: Re: [PATCH 2/3][mmotm] showing size of kcore v2
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 2:10 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 17 Sep 2009 14:02:39 +0800
> Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> > @@ -124,6 +126,7 @@ static void __kcore_update_ram(struct li
>> >        write_unlock(&kclist_lock);
>> >
>> >        free_kclist_ents(&garbage);
>> > +       proc_root_kcore->size = get_kcore_size(&nphdr, &size);
>>
>>
>> This makes me to think if we will have some race condition here?
>> Two processes can open kcore at the same time...
>>
> Finally,
> ==
> static void __kcore_update_ram(struct list_head *list)
> {
>  write_lock(&kclist_lock);
>        if (kcore_need_update) {
>                list_for_each_entry_safe(pos, tmp, &kclist_head, list) {
>                        if (pos->type == KCORE_RAM
>                                || pos->type == KCORE_VMEMMAP)
>                                list_move(&pos->list, &garbage);
>                }
>                list_splice_tail(list, &kclist_head);
>        } else
>                list_splice(list, &garbage);
>        kcore_need_update = 0;
>        write_unlock(&kclist_lock);
> }
>
> kclist itself is double checked under write_lock.
> And, once updated, get_kcore_size()'s return vaule is static.


Imagine one process does get_kcore_size(), then another process
is scheduled, who also does get_kcore_size() but at this time,
memory size is changed, so it gets a different value. If then the
second process writes to proc_root_kcore->size before the first one
does, the proc_root_kcore->size is wrong.

Am I missing something here?

> So, I think there are no race. But..Hmm...is this clearer ?
>
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Yes, this version should be OK.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>
> Now, size of /proc/kcore which can be read by 'ls -l' is 0.
> But it's not correct value.
>
> This is a patch for showing size of /proc/kcore as following.
>
> On x86-64, ls -l shows
>  ... root root 140737486266368 2009-09-17 10:29 /proc/kcore
> Then, 7FFFFFFE02000. This comes from vmalloc area's size.
> This shows "core" size, not  memory size.
>
> This patch shows the size by updating "size" field in struct proc_dir_entry.
> Later, lookup routine will create inode and fill inode->i_size based
> on this value. Then, this has a problem.
>
>  - Once inode is cached, inode->i_size will never be updated.
>
> Then, this patch is not memory-hotplug-aware.
>
> To update inode->i_size, we have to know dentry or inode.
> But there is no way to lookup them by inside kernel. Hmmm....
> Next patch will try it.
>
> Changelog:
>  -moved upadting ->size under lock.
>
> Cc: WANG Cong <xiyou.wangcong@gmail.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/proc/kcore.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> Index: mmotm-2.6.31-Sep14/fs/proc/kcore.c
> ===================================================================
> --- mmotm-2.6.31-Sep14.orig/fs/proc/kcore.c
> +++ mmotm-2.6.31-Sep14/fs/proc/kcore.c
> @@ -107,6 +107,8 @@ static void free_kclist_ents(struct list
>  */
>  static void __kcore_update_ram(struct list_head *list)
>  {
> +       int nphdr;
> +       size_t size;
>        struct kcore_list *tmp, *pos;
>        LIST_HEAD(garbage);
>
> @@ -121,6 +123,7 @@ static void __kcore_update_ram(struct li
>        } else
>                list_splice(list, &garbage);
>        kcore_need_update = 0;
> +       proc_root_kcore->size = get_kcore_size(&nphdr, &size);
>        write_unlock(&kclist_lock);
>
>        free_kclist_ents(&garbage);
> @@ -429,7 +432,8 @@ read_kcore(struct file *file, char __use
>        unsigned long start;
>
>        read_lock(&kclist_lock);
> -       proc_root_kcore->size = size = get_kcore_size(&nphdr, &elf_buflen);
> +       size = get_kcore_size(&nphdr, &elf_buflen);
> +
>        if (buflen == 0 || *fpos >= size) {
>                read_unlock(&kclist_lock);
>                return 0;
>
>
>
>
>
>
>
>
