Return-Path: <linux-kernel-owner+w=401wt.eu-S933568AbXCONqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbXCONqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933569AbXCONqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:46:10 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46041 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933568AbXCONqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:46:09 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: partial write handling fix
References: <871wjrg6qf.fsf@sw.ru> <20070315122127.GO15400@kernel.dk>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Thu, 15 Mar 2007 16:46:32 +0300
In-Reply-To: <20070315122127.GO15400@kernel.dk> (Jens Axboe's message of "Thu, 15 Mar 2007 13:21:27 +0100")
Message-ID: <87fy86oc07.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Wed, Mar 14 2007, Dmitriy Monakhov wrote:
>> currently if partial write has happened while ->commit_write() then page
>> wasn't marked as accessed and rebalanced. 
>
> The ->commit_write() return values aren't very well designed imho. Is
> your fix correct getting the pipe_to_file() return value correct now?
I think yes, after my patch this path look like follows:

        ret = mapping->a_ops->commit_write(file, page, offset, offset+this_len);
        if (ret) {
                if(ret == AOP_TRUNCATED_PAGE) {
                        page_cache_release(page);
                        goto find_page;
                }
                if (ret < 0)
                        goto out;
                /*
                 * Partial write has happened, so 'ret' already initialized by
                 * number of bytes written, Where is nothing we have to do here.
                 */
        } else
                ret = this_len;
        /*
         * Return the number of bytes written and mark page as
         * accessed, we are now done!
         */
        mark_page_accessed(page);
        balance_dirty_pages_ratelimited(mapping);
out:
        page_cache_release(page);
        unlock_page(page);
out_ret:
        return ret;
}

But off corse this patch does't fix issues spotted by Nick. 
>
> -- 
> Jens Axboe
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

