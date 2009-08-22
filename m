Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbZHVW1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbZHVW1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 18:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932977AbZHVW1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 18:27:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858AbZHVW1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 18:27:09 -0400
Subject: Re: 2.6.31-rc6: Oops in fsnotify
From: Eric Paris <eparis@redhat.com>
To: Grant Wilson <grant.wilson@zen.co.uk>
Cc: Eric Paris <eparis@parisplace.org>, aviro@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090821072516.0ac7bbab@worthy.swandive.local>
References: <20090820164818.6039c185@worthy.swandive.local>
	 <7e0fb38c0908201922r6f9598f9ja95623ea6cf11254@mail.gmail.com>
	 <20090821072516.0ac7bbab@worthy.swandive.local>
Content-Type: text/plain
Date: Sat, 22 Aug 2009 18:27:06 -0400
Message-Id: <1250980027.3126.50.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 07:25 +0100, Grant Wilson wrote:
> On Thu, 20 Aug 2009 22:22:34 -0400
> Eric Paris <eparis@parisplace.org> wrote:
> 
> > I'll take a close look in the morning.  I don't offhand see how this
> > is possible without calling vfs_unlink on a negative dentry (does that
> > even make sense?)
> > 
> > What was the filesystem you are dealing with?  Odd, very, odd (as with
> > all the problems people find in my notify code)
> > 
> The filesystem is ext4 (converted from ext3).

I got the assembly from Grant, it's actually very easy to map it back to
the code but I don't see any problems!

RIP: 0010:[<ffffffff8111bf93>]  [<ffffffff8111bf93>] fsnotify+0x93/0x150
RSP: 0018:ffff880120c89d88  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88012b8aadcc RSI: 0000000000000000 RDI: ffff88012b8aadc8
RBP: ffff880120c89df8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000200
R13: 0000000008000200 R14: ffff8801286bf760 R15: 0000000000000000
FS:  00007f10fd749750(0000) GS:ffff88002f000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
DR2: 0000000000000000 CR3: 0000000120c59000 CR4: 00000000000026f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

ffffffff8111bf77:       e8 94 ce f6 ff          callq  ffffffff81088e10 <srcu_read_lock>
ffffffff8111bf7c:       48 8b 1d 3d b5 6d 00    mov    0x6db53d(%rip),%rbx        # ffffffff817f74c0 <fsnotify_groups>
ffffffff8111bf83:       89 45 ac                mov    %eax,-0x54(%rbp)
ffffffff8111bf86:       48 c7 45 c8 00 00 00    movq   $0x0,-0x38(%rbp)
ffffffff8111bf8d:       00
ffffffff8111bf8e:       eb 03                   jmp    ffffffff8111bf93 <fsnotify+0x93>
ffffffff8111bf90:       48 8b 1b                mov    (%rbx),%rbx
ffffffff8111bf93:       48 8b 03                mov    (%rbx),%rax     <----------------------IP IS HERE
ffffffff8111bf96:       48 81 fb c0 74 7f 81    cmp    $0xffffffff817f74c0,%rbx
ffffffff8111bf9d:       0f 18 08                prefetcht0 (%rax)
ffffffff8111bfa0:       74 36                   je     ffffffff8111bfd8 <fsnotify+0xd8>
ffffffff8111bfa2:       44 85 63 10             test   %r12d,0x10(%rbx)   <--- [if (test_mask &group->mask)]
ffffffff8111bfa6:       74 e8                   je     ffffffff8111bf90 <fsnotify+0x90>
ffffffff8111bfa8:       48 8b 43 20             mov    0x20(%rbx),%rax
ffffffff8111bfac:       44 89 ea                mov    %r13d,%edx
ffffffff8111bfaf:       4c 89 f6                mov    %r14,%rsi
ffffffff8111bfb2:       48 89 df                mov    %rbx,%rdi
ffffffff8111bfb5:       ff 10                   callq  *(%rax) <-------------- [group->ops->should_send_event()]
ffffffff8111bfb7:       84 c0                   test   %al,%al
ffffffff8111bfb9:       74 d5                   je     ffffffff8111bf90 <fsnotify+0x90>
ffffffff8111bfbb:       48 83 7d c8 00          cmpq   $0x0,-0x38(%rbp)
ffffffff8111bfc0:       74 46                   je     ffffffff8111c008 <fsnotify+0x108> <- [fsnotify_create_event()]
ffffffff8111bfc2:       48 8b 43 20             mov    0x20(%rbx),%rax
ffffffff8111bfc6:       48 8b 75 c8             mov    -0x38(%rbp),%rsi
ffffffff8111bfca:       48 89 df                mov    %rbx,%rdi
ffffffff8111bfcd:       ff 50 08                callq  *0x8(%rax) <----------- [group->ops->handle_event()]
ffffffff8111bfd0:       eb be                   jmp    ffffffff8111bf90 <fsnotify+0x90>
ffffffff8111bfd2:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
ffffffff8111bfd8:       8b 75 ac                mov    -0x54(%rbp),%esi
ffffffff8111bfdb:       48 c7 c7 60 b3 3f 82    mov    $0xffffffff823fb360,%rdi
ffffffff8111bfe2:       e8 c9 cd f6 ff          callq  ffffffff81088db0 <srcu_read_unlock>

Here is the code segment from fsnotify():

        idx = srcu_read_lock(&fsnotify_grp_srcu);
        list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
                if (test_mask & group->mask) {
                        if (!group->ops->should_send_event(group, to_tell, mask))
                                continue;
                        if (!event) {
                                event = fsnotify_create_event(to_tell, mask, data,
                                                              data_is, file_name, cookie,
                                                              GFP_KERNEL);
                                /* shit, we OOM'd and now we can't tell, maybe
                                 * someday someone else will want to do something
                                 * here */
                                if (!event)
                                        break;
                        }
                        group->ops->handle_event(group, event);
                }
        }
        srcu_read_unlock(&fsnotify_grp_srcu, idx);

So the IP is clearly inside the 'list_for_each_entry_rcu.'   This means
that somehow a ->next pointer = NULL.  The anchor for this list
(fsnotify_groups) is declared as LIST_HEAD(fsnotify_groups); so it can't
point to NULL.  So I have to look at things that can get added/removed.
fsnotify_obtain_group() does the only addition (using list_add_rcu) and
holding the fsnotify_grp_mutex.  __fsnotify_evict_group() does a
list_del_rcu() (which doesn't change the forward pointer) and also hold
the correct mutex.  These are the only 2 manipulation sites for objects
on the list and they are clearly protected by the fsnotify_grp_mutex.

So if all of the list manipulation has proper synchronization the
concern then becomes if an object was removed from the list (properly)
and freed (improperly) and had it's ->next pntr set to NULL before the
rcu timeouts.  But in fsnotify_put_group() I have:

        __fsnotify_evict_group(group);
        mutex_unlock(&fsnotify_grp_mutex);
        synchronize_srcu(&fsnotify_grp_srcu);
        fsnotify_destroy_group(group);

So the group is taken off of the list in __fsnotify_evict_group() and
then we imediately wait for the fsnotify_grp_srcu which is protecting
the read section where we hit a bug.  So it doesn't look possible that
the object could have been freed while it was still in use by this list.

Maybe someone a lot smarter than me or someone who understands {s,}rcu a
lot better than I do can show me something that I've done wrong, but I'm
having problems seeing anything.  The only thing I can imagine is that
something was scribbling in random memory it didn't own.  I'm sorry
Grant, but I don't see what is wrong here!  If you keep getting bugs,
especially if they happen in random places, I'd suggest either dying RAM
or blame some other random subsystem   :)

-Eric

