Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0BVR5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:57:54 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60791 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0BVR5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jV5KSfvRykqeQHgHv1gcpF07hNoNF6RyBi13JFjuNv6jNwNJTzERPe5IZsSRZNkYrM
         u4k5ZdQSuVUynhbTxCg1Eqi4VkM+4uNflSJzopQ9DWMGfIN6B4HAcJPXS1t0uduop8av
         /1UQY7EUGdbmYV0gXWFhjz9L9JuFe6hV6i+Us=
MIME-Version: 1.0
In-Reply-To: <OFB51E93AB.187F855F-ONC12576D2.00618F62-C12576D2.0061DEB5@transmode.se>
References: <a9e22dff1002220826p63209a33n27e84ea10e191a19@mail.gmail.com> 
	<a9e22dff1002220840x7e86a1a0i3d44cefc1c6a79c0@mail.gmail.com> 
	<OFB51E93AB.187F855F-ONC12576D2.00618F62-C12576D2.0061DEB5@transmode.se>
From: niam <niam.niam@gmail.com>
Date: Mon, 22 Feb 2010 19:57:29 +0200
Message-ID: <a9e22dff1002220957r469ea79cg38309ffd24c19644@mail.gmail.com>
Subject: Re: [PATCH] jffs2: fix memory leak if the sector was successfully 
	erased
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: David Woodhouse <dwmw2@infradead.org>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are right.
Michael Trimarchi also responded that it's freed by the callback.

My concern now that it's not obvious to free erase instruction in
jffs2_erase_callback.
Why not to free it the same piece of code where it was allocated?

--Dima

On Mon, Feb 22, 2010 at 7:49 PM, Joakim Tjernlund
<joakim.tjernlund@transmode.se> wrote:
> niam <niam.niam@gmail.com> wrote on 2010/02/22 17:40:11:
>>
>> Resending patch to proper people/mailing list.
>>
>> Memory allocated for erase instruction is not freed if the sector was
>> successfully erased.
>
> NAK, jffs2_erase_callback() will free it so
> you have added a double free I think. Did you measure a memory leak?
>
>>
>> Signed-off-by: Dmytro Milinevskyy <niam.niam@gmail.com>
>> ---
>>  fs/jffs2/erase.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
>> index b47679b..c0a5604 100644
>> --- a/fs/jffs2/erase.c
>> +++ b/fs/jffs2/erase.c
>> @@ -74,8 +74,10 @@ static void jffs2_erase_block(struct jffs2_sb_info *c,
>>        ((struct erase_priv_struct *)instr->priv)->c = c;
>>
>>        ret = c->mtd->erase(c->mtd, instr);
>> -       if (!ret)
>> +       if (!ret) {
>> +        kfree(instr);
>>                return;
>> +    }
>>
>>        bad_offset = instr->fail_addr;
>>        kfree(instr);
>>
>
>
