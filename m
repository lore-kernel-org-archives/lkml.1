Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYHBC64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYHBC64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYHBC6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:58:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51282 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYHBC6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:58:48 -0400
Message-ID: <4893CCE5.7020907@cn.fujitsu.com>
Date: Sat, 02 Aug 2008 10:56:37 +0800
From: zhangxiliang <zhangxiliang@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
CC: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       viro@zeniv.linux.org.uk, Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yu Zhiguo <yuzg@cn.fujitsu.com>
Subject: Re: [PATCH] Fix the kernel panic of audit_filter_task when key field
 is set
References: <4892F063.1080109@cn.fujitsu.com> <4893C42A.60803@cn.fujitsu.com> <4893CBA9.9020008@cn.fujitsu.com>
In-Reply-To: <4893CBA9.9020008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I miss a blank between if and "(". 
And I add "unlikely" to check "ctx" in audit_match_perm() and audit_match_filetype().
This is a new patch for it.

Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
---
 kernel/auditsc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4699950..57a001a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -243,6 +243,9 @@ static inline int open_arg(int flags, int mask)
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
 {
+	if (unlikely(!ctx))
+		return 0;
+
 	unsigned n = ctx->major;
 	switch (audit_classify_syscall(ctx->arch, n)) {
 	case 0:	/* native */
@@ -284,6 +287,10 @@ static int audit_match_filetype(struct audit_context *ctx, int which)
 {
 	unsigned index = which & ~S_IFMT;
 	mode_t mode = which & S_IFMT;
+
+	if (unlikely(!ctx))
+		return 0;
+
 	if (index >= ctx->name_count)
 		return 0;
 	if (ctx->names[index].ino == -1)

Yu Zhiguo said the following on 2008-08-02 10:51:
> 
> zhangxiliang wrote:
> 
>>  static int audit_match_perm(struct audit_context *ctx, int mask)
>>  {
>> +    if(!ctx)
>> +        return 0;
>>      unsigned n = ctx->major;
> 
> Please check this patch with scripts/checkpatch.pl and then resend it.
> 
> 
>>      switch (audit_classify_syscall(ctx->arch, n)) {
>>      case 0:    /* native */
>> @@ -284,6 +286,8 @@ static int audit_match_filetype(struct
>> audit_context *ctx, int which)
>>  {
>>      unsigned index = which & ~S_IFMT;
>>      mode_t mode = which & S_IFMT;
>> +    if(!ctx)
>> +        return 0;
>>      if (index >= ctx->name_count)
>>          return 0;
>>      if (ctx->names[index].ino == -1)
>>
>>
> 
> 
> 
> 

