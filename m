Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZJEBpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZJEBpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 21:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbZJEBpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 21:45:11 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54642 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbZJEBpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 21:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ESg6UjMCy3TG8j4/PyRt+Ohpz/tiBD8BWBLw/vhl0t0j70ZMD+qvn55CY6cpwn9kc5
         CaWZ27jVohBSSHfCE4brkWGjC0NHjIlX6fX7V1AkrLWHaEGGYaFcn6SJpdhfAfmxCb3a
         tOT+en0Lwl9d3O1+Bwn8Lz0GUkqmeV1QD1zcM=
MIME-Version: 1.0
In-Reply-To: <20091005103744.5F83.A69D9226@jp.fujitsu.com>
References: <3e8340490910041105p327396e8v39b1a3454c0922bf@mail.gmail.com> 
	<20091005095121.5F7A.A69D9226@jp.fujitsu.com> <20091005103744.5F83.A69D9226@jp.fujitsu.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sun, 4 Oct 2009 21:44:13 -0400
Message-ID: <3e8340490910041844w63720cfq7981c8f5364229de@mail.gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 9:38 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> The improvement idea is here.
>>
>> Changelog
>>   - Added task_lock() to prctl(PR_SET_PROCTITLE_AREA)
>>  -  Added small input sanity check to prctl(PR_SET_PROCTITLE_AREA)
>
> Doh, task_lock() is obviously wrong. please forget this.

As another note, in general I think we'd need to hold a lock over the
entire operation. After all, if userspace changes its PROCTITLE_AREA,
and then reuses the memory for something else, we have an information
leak.

Perhaps a simpler approach would simply be to add a generation
counter. Read it once at the start, barrier, then grab the title. Then
at the end, read the generation counter again. If the value changed,
we need to start over. Also, in this case, an error when reading the
target process' memory should be ignored and retried, as we may have
hit a race in which the target process unmapped the proctitle area
after changing it.
