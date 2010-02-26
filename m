Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935334Ab0BZGbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 01:31:33 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51180 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935284Ab0BZGbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 01:31:32 -0500
Message-Id: <201002260631.o1Q6VPJR039909@www262.sakura.ne.jp>
Subject: Re: [AppArmor #4 0/12] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.johansen@canonical.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Feb 2010 15:31:25 +0900
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>   
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 25022010 #3421183, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding match.c

 33 static struct table_header *unpack_table(void *blob, size_t bsize)
(...snipped...)
 48         blob += sizeof(struct table_header);
Adding against "void *" is gcc specific.

 54         tsize = table_size(th.td_lolen, th.td_flags);
Is tsize != 0 (i.e. integer overflow never happen) guaranteed?





188 struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
(...snipped...)
215         while (size > 0) {
216                 struct table_header *table;
217                 table = unpack_table(blob, size);
218                 if (!table)
219                         goto fail;
220 

You need to do

		if (table->td_id < YYTD_ID_TSIZE)
			dfa->tables[table->td_id] = table;

now in order to let aa_dfa_free(dfa) to free_table().
You might rather want to do

		if (table->td_id < YYTD_ID_TSIZE && !dfa->tables[table->td_id])
			dfa->tables[table->td_id] = table;
		else
			goto fail;

in case duplicated entries are found.

221                 switch (table->td_id) {
222                 case YYTD_ID_ACCEPT:
223                         if (!(table->td_flags & ACCEPT1_FLAGS(flags)))
224                                 goto fail;
225                         break;
226                 case YYTD_ID_ACCEPT2:
227                         if (!(table->td_flags & ACCEPT2_FLAGS(flags)))
228                                 goto fail;
229                         break;
230                 case YYTD_ID_BASE:
231                         if (table->td_flags != YYTD_DATA32)
232                                 goto fail;
233                         break;
234                 case YYTD_ID_DEF:
235                 case YYTD_ID_NXT:
236                 case YYTD_ID_CHK:
237                         if (table->td_flags != YYTD_DATA16)
238                                 goto fail;
239                         break;
240                 case YYTD_ID_EC:
241                         if (table->td_flags != YYTD_DATA8)
242                                 goto fail;
243                         break;
244                 default:
245                         free_table(table);

This "free_table(table);" is not needed as aa_dfa_free(dfa) will do it.

246                         goto fail;
247                 }
248                 dfa->tables[table->td_id] = table;

This "dfa->tables[table->td_id] = table;" is too late.

249                 blob += table_size(table->td_lolen, table->td_flags);
250                 size -= table_size(table->td_lolen, table->td_flags);
251         }





Regarding policy.c

606 struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat)
607 {
608         struct aa_profile *profile = NULL;
609         char *name;
610         u32 sid = aa_alloc_sid(AA_ALLOC_SYS_SID);
611 
612         /* freed below */
613         name = kmalloc(strlen(parent->base.hname) + 2 + 7 + 8, GFP_KERNEL);
614         if (!name)
615                 goto fail;
616         sprintf(name, "%s//null-%x", parent->base.hname, sid);
617 
618         profile = aa_alloc_profile(name);
619         kfree(name);
620         if (!profile)
621                 goto fail;
622 
623         profile->sid = aa_alloc_sid(AA_ALLOC_SYS_SID);

Why calling aa_alloc_sid(AA_ALLOC_SYS_SID) again rather than using sid?
