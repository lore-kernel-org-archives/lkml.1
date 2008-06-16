Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYFPPKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYFPPKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbYFPPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:10:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:63819 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbYFPPJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:09:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nZoFVH1vALMHoDQCpfddXte3pGKj1GMfTevioLh+fx60y6Su6noVw1aljhqFNotblz
         NU1l1lQdRSBi9cDxMMwtKzAWwpUOb8KeFmrR1GWRjXRZM+ZGxUvEp0/DsB9Voc3Sb23x
         8aD2n9ZRHa1MZdnwn4mjBZ5NUq8TUt0Qf9RRA=
Message-ID: <76bd70e30806160809o495dd50fw88a80ec0673c0dc1@mail.gmail.com>
Date: Mon, 16 Jun 2008 11:09:52 -0400
From: "Chuck Lever" <chucklever@gmail.com>
To: "Peter Staubach" <staubach@redhat.com>
Subject: Re: [PATCH] knfsd: nfsd: Handle ERESTARTSYS from syscalls.
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48565F19.10508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613213759.26929.patches@notabene>
	 <1080613114215.27095@suse.de> <48565F19.10508@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 8:39 AM, Peter Staubach <staubach@redhat.com> wrote:
> NeilBrown wrote:
>>
>> OCFS2 can return -ERESTARTSYS from write requests (and possibly
>> elsewhere) if there is a signal pending.
>>
>> If nfsd is shutdown (by sending a signal to each thread) while there
>> is still an IO load from the client, each thread could handle one last
>> request with a signal pending.  This can result in -ERESTARTSYS
>> which is not understood by nfserrno() and so is reflected back to
>> the client as nfserr_io aka -EIO.  This is wrong.
>>
>> Instead, interpret ERESTARTSYS to mean "don't send a reply".
>> The client will resend and - if the server is restarted - the write will
>> (hopefully) be successful and everyone will be happy.
>>
>>
>
> Why not handle -ERESTARTSYS in the same fashion as -ETIMEDOUT, ie.
> leading to a EJUKEBOX sort of error being returned if possible?
>
> Simply not returning is a bad thing to do for anything other than
> NFSv2.  It is especially bad for NFSv4.

Actually, the NFSv4 spec *requires* the server to reply to every request.

Not replying means an NFSv4 client connected via NFSv4 will have to
disconnect and retransmit.  That should be avoided if at all possible.

I think an error reply is much better than no reply in nearly every
case.  NFS3ERR_JUKEBOX/NFS4ERR_DELAY is an interesting idea, but
something else again will probably be required for v4.1 with sessions.

>> Signed-off-by: Neil Brown <neilb@suse.de>
>>
>> ### Diffstat output
>>  ./fs/nfsd/nfsproc.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> ----
>> Funny how the shortest patches sometimes have the longest
>> descriptions.
>>
>> The symptom that I narrowed down to this was:
>>   copy a large file via NFS to an OCFS2 filesystem, and restart
>>   the nfs server during the copy.
>>   The 'cp' might get an -EIO, and the file will be corrupted -
>>   presumably holes in the middle were writes appeared to fail.
>>
>> diff .prev/fs/nfsd/nfsproc.c ./fs/nfsd/nfsproc.c
>> --- .prev/fs/nfsd/nfsproc.c     2008-06-13 21:31:53.000000000 +1000
>> +++ ./fs/nfsd/nfsproc.c 2008-06-13 21:31:57.000000000 +1000
>> @@ -614,6 +614,7 @@ nfserrno (int errno)
>>  #endif
>>                { nfserr_stale, -ESTALE },
>>                { nfserr_jukebox, -ETIMEDOUT },
>> +               { nfserr_dropit, -ERESTARTSYS },
>>                { nfserr_dropit, -EAGAIN },
>>                { nfserr_dropit, -ENOMEM },
>>                { nfserr_badname, -ESRCH },
>>
>> ### Diffstat output
>>  ./fs/nfsd/nfsproc.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff .prev/fs/nfsd/nfsproc.c ./fs/nfsd/nfsproc.c
>> --- .prev/fs/nfsd/nfsproc.c     2008-06-13 21:31:53.000000000 +1000
>> +++ ./fs/nfsd/nfsproc.c 2008-06-13 21:31:57.000000000 +1000
>> @@ -614,6 +614,7 @@ nfserrno (int errno)
>>  #endif
>>                { nfserr_stale, -ESTALE },
>>                { nfserr_jukebox, -ETIMEDOUT },
>> +               { nfserr_dropit, -ERESTARTSYS },
>>                { nfserr_dropit, -EAGAIN },
>>                { nfserr_dropit, -ENOMEM },
>>                { nfserr_badname, -ESRCH },
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
I am certain that these presidents will understand the cry of the
people of Bolivia, of the people of Latin America and the whole world,
which wants to have more food and not more cars. First food, then if
something's left over, more cars, more automobiles. I think that life
has to come first.
-- Evo Morales
