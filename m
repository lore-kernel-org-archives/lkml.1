Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbXEPNh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbXEPNh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbXEPNgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:36:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2078 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760899AbXEPNgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:36:06 -0400
Date: Tue, 15 May 2007 09:20:10 +0000
From: Pavel Machek <pavel@ucw.cz>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070515092010.GE6816@ucw.cz>
References: <20070514110607.549397248@suse.de> <20070514110621.655650997@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514110621.655650997@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Pathname matching, transition table loading, profile loading and
> manipulation.

So we get small interpretter of state machines, and reason we need is
is 'apparmor is misdesigned and works with paths when it should have
worked with handles'.

If you solve the 'new file problem', aa becomes subset of selinux..
And I'm pretty sure patch will be nicer than this.

							Pavel

> +int unpack_dfa(struct aa_dfa *dfa, void *blob, size_t size)
> +{
> +	int hsize, i;
> +	int error = -ENOMEM;
> +
> +	/* get dfa table set header */
> +	if (size < sizeof(struct table_set_header))
> +		goto fail;
> +
> +	if (ntohl(*(u32 *)blob) != YYTH_MAGIC)
> +		goto fail;
> +
> +	hsize = ntohl(*(u32 *)(blob + 4));
> +	if (size < hsize)
> +		goto fail;
> +
> +	blob += hsize;
> +	size -= hsize;
> +
> +	error = -EPROTO;
> +	while (size > 0) {
> +		struct table_header *table;
> +		table = unpack_table(blob, size);
> +		if (!table)
> +			goto fail;
> +
> +		switch(table->td_id) {
> +		case YYTD_ID_ACCEPT:
> +		case YYTD_ID_BASE:
> +			dfa->tables[table->td_id - 1] = table;
> +			if (table->td_flags != YYTD_DATA32)
> +				goto fail;
> +			break;
> +		case YYTD_ID_DEF:
> +		case YYTD_ID_NXT:
> +		case YYTD_ID_CHK:
> +			dfa->tables[table->td_id - 1] = table;
> +			if (table->td_flags != YYTD_DATA16)
> +				goto fail;
> +			break;
> +		case YYTD_ID_EC:
> +			dfa->tables[table->td_id - 1] = table;
> +			if (table->td_flags != YYTD_DATA8)
> +				goto fail;
> +			break;
> +		default:
> +			kfree(table);
> +			goto fail;
> +		}
> +
> +		blob += table_size(table->td_lolen, table->td_flags);
> +		size -= table_size(table->td_lolen, table->td_flags);
> +	}
> +
> +	return 0;
> +
> +fail:
> +	for (i = 0; i < ARRAY_SIZE(dfa->tables); i++) {
> +		if (dfa->tables[i]) {
> +			kfree(dfa->tables[i]);
> +			dfa->tables[i] = NULL;
> +		}
> +	}
> +	return error;
> +}
> +
> +/**
> + * verify_dfa - verify that all the transitions and states in the dfa tables
> + *              are in bounds.
> + * @dfa: dfa to test
> + *
> + * assumes dfa has gone through the verification done by unpacking
> + */
> +int verify_dfa(struct aa_dfa *dfa)
> +{
> +	size_t i, state_count, trans_count;
> +	int error = -EPROTO;
> +
> +	/* check that required tables exist */
> +	if (!(dfa->tables[YYTD_ID_ACCEPT -1 ] &&
> +	      dfa->tables[YYTD_ID_DEF - 1] &&
> +	      dfa->tables[YYTD_ID_BASE - 1] &&
> +	      dfa->tables[YYTD_ID_NXT - 1] &&
> +	      dfa->tables[YYTD_ID_CHK - 1]))
> +		goto out;
> +
> +	/* accept.size == default.size == base.size */
> +	state_count = dfa->tables[YYTD_ID_BASE - 1]->td_lolen;
> +	if (!(state_count == dfa->tables[YYTD_ID_DEF - 1]->td_lolen &&
> +	      state_count == dfa->tables[YYTD_ID_ACCEPT - 1]->td_lolen))
> +		goto out;
> +
> +	/* next.size == chk.size */
> +	trans_count = dfa->tables[YYTD_ID_NXT - 1]->td_lolen;
> +	if (trans_count != dfa->tables[YYTD_ID_CHK - 1]->td_lolen)
> +		goto out;
> +
> +	/* if equivalence classes then its table size must be 256 */
> +	if (dfa->tables[YYTD_ID_EC - 1] &&
> +	    dfa->tables[YYTD_ID_EC - 1]->td_lolen != 256)
> +		goto out;
> +
> +	for (i = 0; i < state_count; i++) {
> +		if (DEFAULT_TABLE(dfa)[i] >= state_count)
> +			goto out;
> +		if (BASE_TABLE(dfa)[i] >= trans_count + 256)
> +			goto out;
> +	}
> +
> +	for (i = 0; i < trans_count ; i++) {
> +		if (NEXT_TABLE(dfa)[i] >= state_count)
> +			goto out;
> +		if (CHECK_TABLE(dfa)[i] >= state_count)
> +			goto out;
> +	}
> +
> +	error = 0;
> +out:
> +	return error;
> +}
> +
> +struct aa_dfa *aa_match_alloc(void)
> +{
> +	return kzalloc(sizeof(struct aa_dfa), GFP_KERNEL);
> +}
> +
> +void aa_match_free(struct aa_dfa *dfa)
> +{
> +	if (dfa) {
> +		int i;
> +
> +		for (i = 0; i < ARRAY_SIZE(dfa->tables); i++)
> +			kfree(dfa->tables[i]);
> +	}
> +	kfree(dfa);
> +}
> +
> +/**
> + * aa_dfa_match - match @path against @dfa starting in @state
> + * @dfa: the dfa to match @path against
> + * @state: the state to start matching in
> + * @path: the path to match against the dfa
> + *
> + * aa_dfa_match will match the full path length and return the state it
> + * finished matching in. The final state is used to look up the accepting
> + * label.
> + */
> +unsigned int aa_dfa_match(struct aa_dfa *dfa, const char *str)
> +{
> +	u16 *def = DEFAULT_TABLE(dfa);
> +	u32 *base = BASE_TABLE(dfa);
> +	u16 *next = NEXT_TABLE(dfa);
> +	u16 *check = CHECK_TABLE(dfa);
> +	unsigned int state = 1, pos;
> +
> +	/* current state is <state>, matching character *str */
> +	if (dfa->tables[YYTD_ID_EC - 1]) {
> +		u8 *equiv = EQUIV_TABLE(dfa);
> +		while (*str) {
> +			pos = base[state] + equiv[(u8)*str++];
> +			if (check[pos] == state)
> +				state = next[pos];
> +			else
> +				state = def[state];
> +		}
> +	} else {
> +		while (*str) {
> +			pos = base[state] + (u8)*str++;
> +			if (check[pos] == state)
> +				state = next[pos];
> +			else
> +				state = def[state];
> +		}
> +	}
> +	return ACCEPT_TABLE(dfa)[state];
> +}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
