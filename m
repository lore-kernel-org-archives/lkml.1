Return-Path: <linux-kernel-owner+w=401wt.eu-S1763243AbYARRT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763243AbYARRT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760563AbYARRTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:19:16 -0500
Received: from mail.fieldses.org ([66.93.2.214]:53347 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762770AbYARRTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:19:12 -0500
Date: Fri, 18 Jan 2008 12:18:05 -0500
To: Peter Staubach <staubach@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/3] enhanced ESTALE error handling
Message-ID: <20080118171805.GA15158@fieldses.org>
References: <4790C761.1010603@redhat.com> <20080118161443.GB20490@parisc-linux.org> <4790D7C0.30402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4790D7C0.30402@redhat.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 11:45:52AM -0500, Peter Staubach wrote:
> Matthew Wilcox wrote:
>> On Fri, Jan 18, 2008 at 10:36:01AM -0500, Peter Staubach wrote:
>>>  static int path_lookup_create(int dfd, const char *name,
>>> -			      unsigned int lookup_flags, struct nameidata *nd,
>>> -			      int open_flags, int create_mode)
>>> +		unsigned int lookup_flags, struct nameidata *nd,
>>> +		int open_flags, int create_mode)
>>>     
>>
>> Gratuitous reformatting?
>>
>>   
>
> Elimination of an overly long line?

I usually try to gather any coding style, comment grammar, etc., fixes
into a single patch or two at the beginning of a series.  That keeps the
substantive patches (the hardest to understand) shorter.

--b.

>
>>> @@ -1712,7 +1729,10 @@ int open_namei(int dfd, const char *path
>>>  	int acc_mode, error;
>>>  	struct path path;
>>>  	struct dentry *dir;
>>> -	int count = 0;
>>> +	int count;
>>> +
>>> +top:
>>> +	count = 0;
>>>   	acc_mode = ACC_MODE(flag);
>>>  @@ -1739,7 +1759,8 @@ int open_namei(int dfd, const char *path
>>>  	/*
>>>  	 * Create - we need to know the parent.
>>>  	 */
>>> -	error = path_lookup_create(dfd,pathname,LOOKUP_PARENT,nd,flag,mode);
>>> +	error = path_lookup_create(dfd, pathname, LOOKUP_PARENT, nd,
>>> +				flag, mode);
>>>  	if (error)
>>>  		return error;
>>>  @@ -1812,10 +1833,17 @@ ok:
>>>  	return 0;
>>>   exit_dput:
>>> +	if (error == -ESTALE)
>>> +		d_drop(path.dentry);
>>>  	dput_path(&path, nd);
>>>  exit:
>>>  	if (!IS_ERR(nd->intent.open.file))
>>>  		release_open_intent(nd);
>>> +	if (error == -ESTALE) {
>>> +		d_drop(nd->dentry);
>>> +		path_release(nd);
>>> +		goto top;
>>> +	}
>>>     
>>
>> I wonder if a tail-call might not work better here.
>
> "Tail-call"?
>
>    Thanx...
>
>       ps
> -
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
