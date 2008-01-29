Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYA2Fin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYA2Fin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbYA2Fif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:38:35 -0500
Received: from trider-g7.fabbione.net ([195.22.207.161]:36178 "EHLO
	trider-g7.fabbione.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYA2Fie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:38:34 -0500
Date: Tue, 29 Jan 2008 06:38:28 +0100 (CET)
From: "Fabio M. Di Nitto" <fabbione@ubuntu.com>
X-X-Sender: fabbione@trider-g7
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Teigland <teigland@redhat.com>, linux-kernel@vger.kernel.org,
       fabbione@ubuntu.com
Subject: Re: [PATCH 06/19] dlm: align midcomms message buffer
In-Reply-To: <20080126220023.4d1256b6.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801290637010.6826@trider-g7>
References: <1201193442-8260-7-git-send-email-teigland@redhat.com>
 <20080126220023.4d1256b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008, Andrew Morton wrote:

>> On Thu, 24 Jan 2008 10:50:29 -0600 David Teigland <teigland@redhat.com> wrote:
>> From: Fabio M. Di Nitto <fabbione@ubuntu.com>
>>
>> gcc does not guarantee that a static buffer is 64bit aligned. This change
>> allows sparc64 to work.
>>
>
> This buffer is not static: changelog needs fixing: s/static/auto/
>
>> ---
>>  fs/dlm/midcomms.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
>> index f8c69dd..da653b5 100644
>> --- a/fs/dlm/midcomms.c
>> +++ b/fs/dlm/midcomms.c
>> @@ -58,7 +58,7 @@ static void copy_from_cb(void *dst, const void *base, unsigned offset,
>>  int dlm_process_incoming_buffer(int nodeid, const void *base,
>>  				unsigned offset, unsigned len, unsigned limit)
>>  {
>> -	unsigned char __tmp[DLM_INBUF_LEN];
>> +	unsigned char __tmp[DLM_INBUF_LEN] __attribute__((aligned(64)));
>>  	struct dlm_header *msg = (struct dlm_header *) __tmp;
>>  	int ret = 0;
>>  	int err = 0;
>
> Why does DLM require that this thing be 64-bit aligned?
>
> It all looks rather ugly.  Can't this stuff be implemeted within the C type
> system somehow?
>

how about this one:

>From adfe3b0654583d34b0840d20a69e4306d5b98caf Mon Sep 17 00:00:00 2001
Message-Id: <adfe3b0654583d34b0840d20a69e4306d5b98caf.1201584946.git.fabbione@ubuntu.com>
From: Fabio M. Di Nitto <fabbione@ubuntu.com>
Date: Tue, 29 Jan 2008 06:35:20 +0100
Subject: [PATCH 1/1] dlm: align midcomms message buffer

gcc does not guarantee that an auto buffer is 64bit aligned.
This change allows sparc64 to work.

Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
---
:100644 100644 f8c69dd... 53b7af2... M	fs/dlm/midcomms.c
  fs/dlm/midcomms.c |   13 ++++++++-----
  1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index f8c69dd..53b7af2 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -58,8 +58,11 @@ static void copy_from_cb(void *dst, const void *base, unsigned offset,
  int dlm_process_incoming_buffer(int nodeid, const void *base,
  				unsigned offset, unsigned len, unsigned limit)
  {
-	unsigned char __tmp[DLM_INBUF_LEN];
-	struct dlm_header *msg = (struct dlm_header *) __tmp;
+	union {
+		unsigned char __buf[DLM_INBUF_LEN];
+		struct dlm_header dlm;
+	} __tmp;
+	struct dlm_header *msg = &__tmp.dlm;
  	int ret = 0;
  	int err = 0;
  	uint16_t msglen;
@@ -100,8 +103,8 @@ int dlm_process_incoming_buffer(int nodeid, const void *base,
  		   in the buffer on the stack (which should work for most
  		   ordinary messages). */

-		if (msglen > sizeof(__tmp) &&
-		    msg == (struct dlm_header *) __tmp) {
+		if (msglen > DLM_INBUF_LEN &&
+		    msg == &__tmp.dlm) {
  			msg = kmalloc(dlm_config.ci_buffer_size, GFP_KERNEL);
  			if (msg == NULL)
  				return ret;
@@ -119,7 +122,7 @@ int dlm_process_incoming_buffer(int nodeid, const void *base,
  		dlm_receive_buffer(msg, nodeid);
  	}

-	if (msg != (struct dlm_header *) __tmp)
+	if (msg != &__tmp.dlm)
  		kfree(msg);

  	return err ? err : ret;
-- 
1.5.3.8


--
I'm going to make him an offer he can't refuse.
