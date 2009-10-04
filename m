Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZJDUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZJDUzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbZJDUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:55:21 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:60462 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbZJDUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cBIlexhlUYV9ANrnFOXeqGdd2AZKnuRPKeYHh6LtjAJbqEYvKn5nKg0+mMK29xG22n
         OuKOdP43G6B/VX1+VbAocSoJrqT1BFCsGqKkLYyVU2x3yQAhezyVP//8bqMNvn05PFOj
         CN6v5CcU4/CCKY38y/+oUhYXGv4ptqiuqJn6Y=
MIME-Version: 1.0
Date: Sun, 4 Oct 2009 22:54:44 +0200
Message-ID: <4e5e476b0910041354o54c95626g974264976adaf53c@mail.gmail.com>
Subject: bug in elevator/cfq regarding start_time?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
I found that the start_time is not monotonic in the cfqq fifo_list.
The problem seems to be that:
* attempt_merge overrides one of the start_time:
        if (time_after(req->start_time, next->start_time))
                req->start_time = next->start_time;
* then it calls elv_merge_requests, that in turn invokes cfq's
elevator_merge_req_fn, i.e. cfq_merged_requests
* cfq_merged_requests checks start_times to decide whether requests
need to be repositioned
        if (!list_empty(&rq->queuelist) && !list_empty(&next->queuelist) &&
            time_before(next->start_time, rq->start_time))
                list_move(&rq->queuelist, &next->queuelist);

Other I/O schedulers are not affected, since none of them uses
start_time explicitly, but they have a copy in one of the private
fields.

Corrado

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
