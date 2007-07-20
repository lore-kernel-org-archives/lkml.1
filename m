Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbXGTUzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbXGTUzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761978AbXGTUyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:54:53 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3111 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbXGTUyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:54:52 -0400
Date: Fri, 20 Jul 2007 22:22:32 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] totally hanging altough not crashed
Message-ID: <20070720202232.GH25317@vanheusden.com>
References: <20070720195252.GA25317@vanheusden.com> <46A11E7D.90209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A11E7D.90209@redhat.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Jul 21 21:41:40 CEST 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > One of my systems running 2.6.21.1 on a P4 with HT and 2GB of ram
> > occasionally crashes. Not with an oops or panic, it just suddenly stops
> > doing anything. It still lets you ping and it still forwards ip traffic
> > but you can't login: not via ssh and not on the console - pressing enter
> > brings the cursor to the next line and that's it. It is NOT swapping at
> > all, in fact alt+sysrq+m says that there's still plenty of memory and
> > swap available:
> Lots of processes are in uninterruptible wait at
> start_this_handle+0x208/0x365. Can you find out what line of code
> that matches? (There are a few of those waits in that function.)

I hope I follow the correct procedure but in any case gdb tells me this:

0 root@muur:/usr/src/linux$ gdb ./vmlinux
GNU gdb 6.5
Copyright (C) 2006 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "i486-slackware-linux"...l *Using host libthread_db library "/lib/tls/libthread_db.so.1".

(gdb) l *c10c23a0
No symbol "c10c23a0" in current context.
(gdb) p start_this_handle
$1 = {int (journal_t *, handle_t *)} 0xc10c7614 <start_this_handle>
(gdb) l *0xC10C7979
0xc10c7979 is in new_handle (fs/jbd/transaction.c:238).
233             return ret;
234     }
235
236     /* Allocate a new handle.  This should probably be in a slab... */
237     static handle_t *new_handle(int nblocks)
238     {
239             handle_t *handle = jbd_alloc_handle(GFP_NOFS);
240             if (!handle)
241                     return NULL;
242             memset(handle, 0, sizeof(*handle));
(gdb) l *0xC10C781C
0xc10c781c is in start_this_handle (fs/jbd/transaction.c:155).
150
151                     prepare_to_wait(&journal->j_wait_transaction_locked,
152                                             &wait, TASK_UNINTERRUPTIBLE);
153                     spin_unlock(&journal->j_state_lock);
154                     schedule();
155                     finish_wait(&journal->j_wait_transaction_locked, &wait);
156                     goto repeat;
157             }
158
159             /*
(gdb)


Folkert van Heusden

-- 
www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
HP/UX en win een vlaai naar keuze
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
