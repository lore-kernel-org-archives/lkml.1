Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0BTPNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:13:33 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:41989 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab0BTPNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=nKVLSpA/uu8p+Wh0D28gbsJc5aKCxcZmqLUSHQTDLCsjrzw2A1/70z5SGxCNBBXjvZ
         qaMpLBWHg2wexXdGYQnDoCuvmAtocNzYMTILPm1EL3Yj757BK90kppC53mlIO8ymzowT
         qISlbAyFeyEMvv6RWWN8FoB+Q0Fe9vFrMeDpM=
Date: Sat, 20 Feb 2010 23:16:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: sysfs lockdep complaint
Message-ID: <20100220151613.GH3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net> <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com> <1266664814.11514.5.camel@jlt3.sipsolutions.net> <20100220135122.GB3000@hack> <1266674291.18465.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266674291.18465.7.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 02:58:11PM +0100, Johannes Berg wrote:
>On Sat, 2010-02-20 at 21:51 +0800, Américo Wang wrote:
>
>> >BUG: key c0000002165eb478 not in .data!
>> >
>> >instead of the lockdep complaint above.
>> >
>> 
>> I am not surprised. :)
>> 
>> Please send us the backtraces you got, we could expect this.
>
>I hacked in dump_stack() but it overflowed my log buffer, here's an example:
>
>[   31.625411] BUG: key c0000002134f2ab0 not in .data!
>[   31.625414] Call Trace:
>[   31.625417] [c000000213b677c0] [c000000000012c1c] .show_stack+0xc0/0x200 (unreliable)
>[   31.625423] [c000000213b67890] [c0000000005ac968] .dump_stack+0x28/0x3c
>[   31.625428] [c000000213b67910] [c0000000000b6a3c] .lockdep_init_map+0x11c/0x674
>[   31.625433] [c000000213b67a10] [c0000000001efd90] .sysfs_add_file_mode+0x90/0x124
>[   31.625438] [c000000213b67ad0] [c0000000001efe60] .sysfs_add_file+0x3c/0x50
>[   31.625442] [c000000213b67b70] [c0000000001f2f40] .sysfs_create_bin_file+0x5c/0x78
>[   31.625448] [c000000213b67c10] [c0000000000cd0b0] .load_module+0x16a4/0x197c
>[   31.625452] [c000000213b67d80] [c0000000000cd424] .SyS_init_module+0x9c/0x2d4
>[   31.625457] [c000000213b67e30] [c0000000000075d4] syscall_exit+0x0/0x40
>
>There's also
>[   34.776604] BUG: key c000000216265388 not in .data!
>[   34.776606] Call Trace:
>[   34.776609] [c000000213b5f7a0] [c000000000012c1c] .show_stack+0xc0/0x200 (unreliable)
>[   34.776615] [c000000213b5f870] [c0000000005ac968] .dump_stack+0x28/0x3c
>[   34.776620] [c000000213b5f8f0] [c0000000000b6a3c] .lockdep_init_map+0x11c/0x674
>[   34.776624] [c000000213b5f9f0] [c0000000001efd90] .sysfs_add_file_mode+0x90/0x124
>[   34.776629] [c000000213b5fab0] [c0000000001f32b4] .internal_create_group+0x168/0x24c
>[   34.776634] [c000000213b5fb70] [c0000000001f3420] .sysfs_create_group+0x38/0x50
>[   34.776639] [c000000213b5fc10] [c0000000000ccf20] .load_module+0x1514/0x197c
>[   34.776644] [c000000213b5fd80] [c0000000000cd424] .SyS_init_module+0x9c/0x2d4
>[   34.776649] [c000000213b5fe30] [c0000000000075d4] syscall_exit+0x0/0x40
>

Thanks!

This could be fixed by the following.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/kernel/module.c b/kernel/module.c
index f82386b..fa4d562 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1085,6 +1085,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 		sect_attrs->nsections++;
 		sattr->mattr.show = module_sect_show;
 		sattr->mattr.store = NULL;
+		sysfs_attr_init(&sattr->mattr.attr);
 		sattr->mattr.attr.name = sattr->name;
 		sattr->mattr.attr.mode = S_IRUGO;
 		*(gattr++) = &(sattr++)->mattr.attr;
@@ -1178,6 +1179,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 		if (sect_empty(&sechdrs[i]))
 			continue;
 		if (sechdrs[i].sh_type == SHT_NOTE) {
+			sysfs_bin_attr_init(nattr);
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
 			nattr->attr.mode = S_IRUGO;
 			nattr->size = sechdrs[i].sh_size;

