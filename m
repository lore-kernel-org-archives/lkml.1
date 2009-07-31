Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZGaJgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZGaJgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 05:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZGaJgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 05:36:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:39613 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZGaJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 05:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qZ2Xu2XAc0GbY6Oj7+SO9l6a6E80EwS1TKsWdmYayLPGrnNMnXzfjw6mFGVQU5FSvU
         3x7io2qQV90ZXjnnrbJQzgDRE8DjgUveq3WZugbHqlFYRG26lhgx4s55xLRIO5nMjLDx
         vTmYJ98107ZoF8DQ+vJAp822dKXLIy8T+R/fQ=
Date: Fri, 31 Jul 2009 17:38:30 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Mike Smith <scgtrp@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] vmalloc: vread vwrite avoid memory hole.
Message-ID: <20090731093830.GC5048@cr0.nay.redhat.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/> <20090728160527.1da52682.akpm@linux-foundation.org> <20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com> <525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com> <20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com> <20090729173600.540878a3.kamezawa.hiroyu@jp.fujitsu.com> <20090729174810.4aea1283.kamezawa.hiroyu@jp.fujitsu.com> <20090729095932.GG5856@cr0.nay.redhat.com> <20090729205123.978971b8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729205123.978971b8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 08:51:23PM +0900, KAMEZAWA Hiroyuki wrote:
>On Wed, 29 Jul 2009 17:59:32 +0800
>Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Wed, Jul 29, 2009 at 05:48:10PM +0900, KAMEZAWA Hiroyuki wrote:
>> >Considering recent changes, I think this an answer to this bug.
>> >
>> >All get_vm_area() calls specified VM_IOREMAP before 2.6.30.
>> >Now, percpu calls get_vm_area() without IOREMAP (it means kcore doesn't skip this)
>> >And it seems pcpu does delayed map to pre-allocated vmalloc-area.
>> >Then, now, vmalloc() area has memory holes. (I'm sorry if I misunderstand.)
>> 
>> 
>> You mean the guard holes in vmalloc area?
>> 
>no, not guard hole.  memory hole in the middle of valid vmalloc area, like this
>
>start             end
>      XXXXX0XXXXXG   XXXXXXXXG  XXXXXXXXG
>X= pte is present
>O= pte is none
>G= pte is none as guard page.
>


Hmm, I get your meaning now... thanks


>> >+
>> >+static int aligned_vwrite(char *buf, char *addr, unsigned long count)
>> >+{
>> >+	struct page *p;
>> >+	int copied;
>> >+
>> >+	while (count) {
>> >+		unsigned long offset, length;
>> >+
>> >+		offset = (unsinged long)addr & PAGE_MASK;
>> >+		length = PAGE_SIZE - offset;
>> >+		if (length > count)
>> >+			length = count;
>> >+		/* confirm the page is present */
>> >+		p = vmalloc_to_page(addr);
>> >+		if (p)
>> >+			memcpy(addr, buf, length);
>> 
>> 
>> So when !p, you copy nothing, but still increase the length,
>> *silently*?
>Ah, thanks, it's careless bug...will fix.
>
>
>
>> 
>> This looks a bit weird for me... I am thinking if we need
>> to return the number of bytes that is *actually* copied?
>> 
>I think it makes the caller complex.
>
>Then, I have 2 options.
> a) skip memory hole
> b) if we find memory hole, return immediately.
>
>Do you like b) ? 
>But in old behavior, vwrite()/vread() incremetns its "addr"
>(at read zero-fill).
>
>Then, I used a).


Ok, just want to make sure it's safe to do a).



>
>
>> 
>> >+		addr += length;
>> >+		buf += length;
>> >+		copiled += length;
>> >+		count -= length;
>> >+	}
>> >+	return copied;
>> >+}
>> >+
>> >+long vread(char *buf, char *addr, unsigned long count, bool skip_ioremap)
>> > {
>> > 	struct vm_struct *tmp;
>> > 	char *vaddr, *buf_start = buf;
>> >@@ -1640,10 +1694,11 @@ long vread(char *buf, char *addr, unsign
>> > 		count = -(unsigned long) addr;
>> > 
>> > 	read_lock(&vmlist_lock);
>> >-	for (tmp = vmlist; tmp; tmp = tmp->next) {
>> >+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
>> > 		vaddr = (char *) tmp->addr;
>> > 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
>> > 			continue;
>> >+
>> > 		while (addr < vaddr) {
>> > 			if (count == 0)
>> > 				goto finished;
>> >@@ -1653,14 +1708,15 @@ long vread(char *buf, char *addr, unsign
>> > 			count--;
>> > 		}
>> > 		n = vaddr + tmp->size - PAGE_SIZE - addr;
>> >-		do {
>> >-			if (count == 0)
>> >-				goto finished;
>> >-			*buf = *addr;
>> >-			buf++;
>> >-			addr++;
>> >-			count--;
>> >-		} while (--n > 0);
>> >+		if (n > count)
>> >+			n = count;
>> >+		if (!(tmp->flags & VM_IOREMAP) || !skip_ioremap)
>> >+			aligned_vread(buf, addr, n);
>> >+		else
>> >+			memset(buf, 0, n);
>> >+		buf += n;
>> >+		addr += n;
>> >+		count -= n;
>> 
>> 
>> If I set 'skip_ioremap' true, I want the return value can be
>> what it _actually_ copies, i.e. kick out the bytes counted
>> for VM_IOREMAP. What do you think?
>> 
>
>One one od the reasons is The same reason to above. 
>(adjusted to old behavior)
>
>IIUC, In following kind of codes,
>
>	len = vread(buf,addr,xxx);
>	bud += len;
>	addr += len
>
>len should be the length that the caller should increment buffer address.
>So, I just skipped hole.


Well... old code doesn't have the parameter 'skip_ioremap'. :-)
For new code, we can do:

  len = vread(buf, addr, count, true);
  buf += len;
  addr += count;

