Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYJIQs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYJIQs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYJIQso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:48:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49221 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbYJIQsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:48:42 -0400
Date: Thu, 9 Oct 2008 11:48:36 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
Message-ID: <20081009164836.GA5480@us.ibm.com>
References: <20081009042814.398846861@nttdata.co.jp> <20081009042922.939610141@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009042922.939610141@nttdata.co.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):

I am not happy with the locking.

In a previous patch you mark funtions with 'begin/end critical section'.
Please instead put a comment on top listing precisely which locks
the fn expects to be held.

As for protecting your own data, please
	1. explain at the var declaration what lock protects it
	2. define the lock next to the list

For instance, I assume the intent below is for pattern_list to be
protected by the static 'lock' mutex defined in
update_file_pattern_entry.  But get_file_pattern() also walks the
list without any locking.

It looks like you only ever append to the list, with a memory barrier,
so *maybe* it's safe, but your rationale should be spelled out here.

Ideally you would use something like rcu that everyone can easily
recognize.  If you insist on introducing your own list walking and
locking primitives, then please
	1. introduce them separately
	2. add them into list.h (not tomoyo/common.h!)
	3. and get the right folks to ack it.  I'd feel better if Paul
	   McKenney (cc:d) looked and ok'd it, for instance.  (Paul,
	   the relevant helpers are defined in a separate patch though)
You could even protect everything with a big dumb mutex for now and
optimize that in later patches.  That way stuff like this doesn't muck
up the review of the main TOMOYO patches.

> +/* The list for "struct pattern_entry". */
> +static LIST1_HEAD(pattern_list);
> +
> +/**
> + * update_file_pattern_entry - Update "struct pattern_entry" list.
> + *
> + * @pattern:   Pathname pattern.
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +static int update_file_pattern_entry(const char *pattern, const bool is_delete)
> +{
> +	struct pattern_entry *new_entry;
> +	struct pattern_entry *ptr;
> +	static DEFINE_MUTEX(lock);
> +	const struct path_info *saved_pattern;
> +	int error = -ENOMEM;
> +	if (!tmy_is_correct_path(pattern, 0, 1, 0, __func__))
> +		return -EINVAL;
> +	saved_pattern = tmy_save_name(pattern);
> +	if (!saved_pattern)
> +		return -ENOMEM;
> +	mutex_lock(&lock);
> +	list1_for_each_entry(ptr, &pattern_list, list) {
> +		if (saved_pattern != ptr->pattern)
> +			continue;
> +		ptr->is_deleted = is_delete;
> +		error = 0;
> +		goto out;
> +	}
> +	if (is_delete) {
> +		error = -ENOENT;
> +		goto out;
> +	}
> +	new_entry = tmy_alloc_element(sizeof(*new_entry));
> +	if (!new_entry)
> +		goto out;
> +	new_entry->pattern = saved_pattern;
> +	list1_add_tail_mb(&new_entry->list, &pattern_list);
> +	error = 0;
> +out:
> +	mutex_unlock(&lock);
> +	tmy_update_counter(TMY_UPDATES_COUNTER_EXCEPTION_POLICY);
> +	return error;
> +}
> +
> +/**
> + * get_file_pattern - Get patterned pathname.
> + *
> + * @filename: The filename to find patterned pathname.
> + *
> + * Returns pointer to pathname pattern if matched, @filename otherwise.
> + */
> +static const struct path_info *
> +get_file_pattern(const struct path_info *filename)
> +{
> +	struct pattern_entry *ptr;
> +	const struct path_info *pattern = NULL;
> +	list1_for_each_entry(ptr, &pattern_list, list) {
> +		if (ptr->is_deleted)
> +			continue;
> +		if (!tmy_path_matches_pattern(filename, ptr->pattern))
> +			continue;
> +		pattern = ptr->pattern;
> +		if (strendswith(pattern->name, "/\\*")) {
> +			/* Do nothing. Try to find the better match. */
> +		} else {
> +			/* This would be the better match. Use this. */
> +			break;
> +		}
> +	}
> +	if (pattern)
> +		filename = pattern;
> +	return filename;
> +}
> +
> +/**
> + * tmy_write_pattern_policy - Write "struct pattern_entry" list.
> + *
> + * @data:      String to parse.
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tmy_write_pattern_policy(char *data, const bool is_delete)
> +{
> +	return update_file_pattern_entry(data, is_delete);
> +}
> +
> +/**
> + * tmy_read_file_pattern - Read "struct pattern_entry" list.
> + *
> + * @head: Pointer to "struct tmy_io_buffer".
> + *
> + * Returns true on success, false otherwise.
> + */
> +bool tmy_read_file_pattern(struct tmy_io_buffer *head)
> +{
> +	struct list1_head *pos;
> +	list1_for_each_cookie(pos, head->read_var2, &pattern_list) {
> +		struct pattern_entry *ptr;
> +		ptr = list1_entry(pos, struct pattern_entry, list);
> +		if (ptr->is_deleted)
> +			continue;
> +		if (!tmy_io_printf(head, KEYWORD_FILE_PATTERN "%s\n",
> +				   ptr->pattern->name))
> +			goto out;
> +	}
> +	return true;
> +out:
> +	return false;
> +}
> +
> +/* The list for "struct no_rewrite_entry". */
> +static LIST1_HEAD(no_rewrite_list);
> +
> +/**
> + * update_no_rewrite_entry - Update "struct no_rewrite_entry" list.
> + *
> + * @pattern:   Pathname pattern that are not rewritable by default.
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +static int update_no_rewrite_entry(const char *pattern, const bool is_delete)
> +{
> +	struct no_rewrite_entry *new_entry, *ptr;
> +	static DEFINE_MUTEX(lock);
> +	const struct path_info *saved_pattern;
> +	int error = -ENOMEM;
> +	if (!tmy_is_correct_path(pattern, 0, 0, 0, __func__))
> +		return -EINVAL;
> +	saved_pattern = tmy_save_name(pattern);
> +	if (!saved_pattern)
> +		return -ENOMEM;
> +	mutex_lock(&lock);
> +	list1_for_each_entry(ptr, &no_rewrite_list, list) {
> +		if (ptr->pattern != saved_pattern)
> +			continue;
> +		ptr->is_deleted = is_delete;
> +		error = 0;
> +		goto out;
> +	}
> +	if (is_delete) {
> +		error = -ENOENT;
> +		goto out;
> +	}
> +	new_entry = tmy_alloc_element(sizeof(*new_entry));
> +	if (!new_entry)
> +		goto out;
> +	new_entry->pattern = saved_pattern;
> +	list1_add_tail_mb(&new_entry->list, &no_rewrite_list);
> +	error = 0;
> +out:
> +	mutex_unlock(&lock);
> +	tmy_update_counter(TMY_UPDATES_COUNTER_EXCEPTION_POLICY);
> +	return error;
> +}
> +
> +/**
> + * is_no_rewrite_file - Check if the given pathname is not permitted to be rewrited.
> + *
> + * @filename: Filename to check.
> + *
> + * Returns true if @filename is specified by "deny_rewrite" directive,
> + * false otherwise.
> + */
> +static bool is_no_rewrite_file(const struct path_info *filename)
> +{
> +	struct no_rewrite_entry *ptr;
> +	list1_for_each_entry(ptr, &no_rewrite_list, list) {
> +		if (ptr->is_deleted)
> +			continue;
> +		if (!tmy_path_matches_pattern(filename, ptr->pattern))
> +			continue;
> +		return true;
> +	}
> +	return false;
> +}
> +
> +/**
> + * tmy_write_no_rewrite_policy - Write "struct no_rewrite_entry" list.
> + *
> + * @data:      String to parse.
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tmy_write_no_rewrite_policy(char *data, const bool is_delete)
> +{
> +	return update_no_rewrite_entry(data, is_delete);
> +}
> +
> +/**
> + * tmy_read_no_rewrite_policy - Read "struct no_rewrite_entry" list.
> + *
> + * @head: Pointer to "struct tmy_io_buffer".
> + *
> + * Returns true on success, false otherwise.
> + */
> +bool tmy_read_no_rewrite_policy(struct tmy_io_buffer *head)
> +{
> +	struct list1_head *pos;
> +	list1_for_each_cookie(pos, head->read_var2, &no_rewrite_list) {
> +		struct no_rewrite_entry *ptr;
> +		ptr = list1_entry(pos, struct no_rewrite_entry, list);
> +		if (ptr->is_deleted)
> +			continue;
> +		if (!tmy_io_printf(head, KEYWORD_DENY_REWRITE "%s\n",
> +				   ptr->pattern->name))
> +			goto out;
> +	}
> +	return true;
> +out:
> +	return false;
> +}
> +
> +/**
> + * update_file_acl - Update file's read/write/execute ACL.
> + *
> + * @filename:  Filename.
> + * @perm:      Permission (between 1 to 7).
> + * @domain:    Pointer to "struct domain_info".
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + *
> + * This is legacy support interface for older policy syntax.
> + * Current policy syntax uses "allow_read/write" instead of "6",
> + * "allow_read" instead of "4", "allow_write" instead of "2",
> + * "allow_execute" instead of "1".
> + */
> +static int update_file_acl(const char *filename, u8 perm,
> +			   struct domain_info * const domain,
> +			   const bool is_delete)
> +{
> +	if (perm > 7 || !perm) {
> +		printk(KERN_DEBUG "%s: Invalid permission '%d %s'\n",
> +		       __func__, perm, filename);
> +		return -EINVAL;
> +	}
> +	if (filename[0] != '@' && strendswith(filename, "/"))
> +		/*
> +		 * Only 'allow_mkdir' and 'allow_rmdir' are valid for
> +		 * directory permissions.
> +		 */
> +		return 0;
> +	if (perm & 4)
> +		update_single_path_acl(TMY_TYPE_READ_ACL, filename, domain,
> +				       is_delete);
> +	if (perm & 2)
> +		update_single_path_acl(TMY_TYPE_WRITE_ACL, filename, domain,
> +				       is_delete);
> +	if (perm & 1)
> +		update_single_path_acl(TMY_TYPE_EXECUTE_ACL, filename, domain,
> +				       is_delete);
> +	return 0;
> +}
> +
> +/**
> + * check_single_path_acl2 - Check permission for single path operation.
> + *
> + * @domain:          Pointer to "struct domain_info".
> + * @filename:        Filename to check.
> + * @perm:            Permission.
> + * @may_use_pattern: True if patterned ACL is permitted.
> + *
> + * Returns 0 on success, -EPERM otherwise.
> + */
> +static int check_single_path_acl2(const struct domain_info *domain,
> +				  const struct path_info *filename,
> +				  const u16 perm, const bool may_use_pattern)
> +{
> +	struct acl_info *ptr;
> +	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
> +		struct single_path_acl_record *acl;
> +		if (tmy_acl_type2(ptr) != TYPE_SINGLE_PATH_ACL)
> +			continue;
> +		acl = container_of(ptr, struct single_path_acl_record, head);
> +		if (!(acl->perm & perm))
> +			continue;
> +		if (may_use_pattern || !acl->filename->is_patterned) {
> +			if (!tmy_path_matches_pattern(filename,
> +						      acl->filename))
> +				continue;
> +		} else {
> +			continue;
> +		}
> +		return 0;
> +	}
> +	return -EPERM;
> +}
> +
> +/**
> + * check_file_acl - Check permission for opening files.
> + *
> + * @domain:    Pointer to "struct domain_info".
> + * @filename:  Filename to check.
> + * @operation: Mode ("read" or "write" or "read/write" or "execute").
> + *
> + * Returns 0 on success, -EPERM otherwise.
> + */
> +static int check_file_acl(const struct domain_info *domain,
> +			  const struct path_info *filename, const u8 operation)
> +{
> +	u16 perm = 0;
> +	if (!tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE))
> +		return 0;
> +	if (operation == 6)
> +		perm = 1 << TMY_TYPE_READ_WRITE_ACL;
> +	else if (operation == 4)
> +		perm = 1 << TMY_TYPE_READ_ACL;
> +	else if (operation == 2)
> +		perm = 1 << TMY_TYPE_WRITE_ACL;
> +	else if (operation == 1)
> +		perm = 1 << TMY_TYPE_EXECUTE_ACL;
> +	else
> +		BUG();
> +	return check_single_path_acl2(domain, filename, perm, operation != 1);
> +}
> +
> +/**
> + * check_file_perm2 - Check permission for opening files.
> + *
> + * @domain:    Pointer to "struct domain_info".
> + * @filename:  Filename to check.
> + * @perm:      Mode ("read" or "write" or "read/write" or "execute").
> + * @operation: Operation name passed used for verbose mode.
> + * @mode:      Access control mode.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +static int check_file_perm2(struct domain_info * const domain,
> +			    const struct path_info *filename, const u8 perm,
> +			    const char *operation, const u8 mode)
> +{
> +	const bool is_enforce = (mode == 3);
> +	const char *msg = "<unknown>";
> +	int error = 0;
> +	if (!filename)
> +		return 0;
> +	error = check_file_acl(domain, filename, perm);
> +	if (error && perm == 4 &&
> +	    (domain->flags & DOMAIN_FLAGS_IGNORE_GLOBAL_ALLOW_READ) == 0 &&
> +	    is_globally_readable_file(filename))
> +		error = 0;
> +	if (perm == 6)
> +		msg = tmy_sp2keyword(TMY_TYPE_READ_WRITE_ACL);
> +	else if (perm == 4)
> +		msg = tmy_sp2keyword(TMY_TYPE_READ_ACL);
> +	else if (perm == 2)
> +		msg = tmy_sp2keyword(TMY_TYPE_WRITE_ACL);
> +	else if (perm == 1)
> +		msg = tmy_sp2keyword(TMY_TYPE_EXECUTE_ACL);
> +	else
> +		BUG();
> +	if (!error)
> +		return 0;
> +	if (tmy_verbose_mode(domain))
> +		printk(KERN_WARNING "TOMOYO-%s: Access '%s(%s) %s' denied "
> +		       "for %s\n", tmy_get_msg(is_enforce), msg, operation,
> +		       filename->name, tmy_get_last_name(domain));
> +	if (is_enforce)
> +		return error;
> +	if (mode == 1 && tmy_check_domain_quota(domain)) {
> +		/* Don't use patterns for execute permission. */
> +		const struct path_info *patterned_file = (perm != 1) ?
> +			get_file_pattern(filename) : filename;
> +		update_file_acl(patterned_file->name, perm,
> +				domain, false);
> +	}
> +	return 0;
> +}
> +
> +/**
> + * tmy_write_file_policy - Update file related list.
> + *
> + * @data:      String to parse.
> + * @domain:    Pointer to "struct domain_info".
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tmy_write_file_policy(char *data, struct domain_info *domain,
> +			  const bool is_delete)
> +{
> +	char *filename = strchr(data, ' ');
> +	char *filename2;
> +	unsigned int perm;
> +	u8 type;
> +	if (!filename)
> +		return -EINVAL;
> +	*filename++ = '\0';
> +	if (sscanf(data, "%u", &perm) == 1)
> +		return update_file_acl(filename, (u8) perm, domain, is_delete);
> +	if (strncmp(data, "allow_", 6))
> +		goto out;
> +	data += 6;
> +	for (type = 0; type < MAX_SINGLE_PATH_OPERATION; type++) {
> +		if (strcmp(data, sp_keyword[type]))
> +			continue;
> +		return update_single_path_acl(type, filename,
> +					      domain, is_delete);
> +	}
> +	filename2 = strchr(filename, ' ');
> +	if (!filename2)
> +		goto out;
> +	*filename2++ = '\0';
> +	for (type = 0; type < MAX_DOUBLE_PATH_OPERATION; type++) {
> +		if (strcmp(data, dp_keyword[type]))
> +			continue;
> +		return update_double_path_acl(type, filename, filename2, domain,
> +					      is_delete);
> +	}
> +out:
> +	return -EINVAL;
> +}
> +
> +/**
> + * update_single_path_acl - Update "struct single_path_acl_record" list.
> + *
> + * @type:      Type of operation.
> + * @filename:  Filename.
> + * @domain:    Pointer to "struct domain_info".
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +static int update_single_path_acl(const u8 type, const char *filename,
> +				  struct domain_info * const domain,
> +				  const bool is_delete)
> +{
> +	static const u16 rw_mask =
> +		(1 << TMY_TYPE_READ_ACL) | (1 << TMY_TYPE_WRITE_ACL);
> +	const struct path_info *saved_filename;
> +	struct acl_info *ptr;
> +	struct single_path_acl_record *acl;
> +	int error = -ENOMEM;
> +	const u16 perm = 1 << type;
> +	if (!domain)
> +		return -EINVAL;
> +	if (!tmy_is_correct_path(filename, 0, 0, 0, __func__))
> +		return -EINVAL;
> +	saved_filename = tmy_save_name(filename);
> +	if (!saved_filename)
> +		return -ENOMEM;
> +	mutex_lock(&domain_acl_lock);
> +	if (is_delete)
> +		goto delete;
> +	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
> +		if (tmy_acl_type1(ptr) != TYPE_SINGLE_PATH_ACL)
> +			continue;
> +		acl = container_of(ptr, struct single_path_acl_record, head);
> +		if (acl->filename != saved_filename)
> +			continue;
> +		/* Special case. Clear all bits if marked as deleted. */
> +		if (ptr->type & ACL_DELETED)
> +			acl->perm = 0;
> +		acl->perm |= perm;
> +		if ((acl->perm & rw_mask) == rw_mask)
> +			acl->perm |= 1 << TMY_TYPE_READ_WRITE_ACL;
> +		else if (acl->perm & (1 << TMY_TYPE_READ_WRITE_ACL))
> +			acl->perm |= rw_mask;
> +		error = tmy_add_domain_acl(NULL, ptr);
> +		goto out;
> +	}
> +	/* Not found. Append it to the tail. */
> +	acl = tmy_alloc_acl_element(TYPE_SINGLE_PATH_ACL);
> +	if (!acl)
> +		goto out;
> +	acl->perm = perm;
> +	acl->filename = saved_filename;
> +	error = tmy_add_domain_acl(domain, &acl->head);
> +	goto out;
> +delete:
> +	error = -ENOENT;
> +	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
> +		if (tmy_acl_type2(ptr) != TYPE_SINGLE_PATH_ACL)
> +			continue;
> +		acl = container_of(ptr, struct single_path_acl_record, head);
> +		if (acl->filename != saved_filename)
> +			continue;
> +		acl->perm &= ~perm;
> +		if ((acl->perm & rw_mask) != rw_mask)
> +			acl->perm &= ~(1 << TMY_TYPE_READ_WRITE_ACL);
> +		else if (!(acl->perm & (1 << TMY_TYPE_READ_WRITE_ACL)))
> +			acl->perm &= ~rw_mask;
> +		error = tmy_del_domain_acl(acl->perm ? NULL : ptr);
> +		break;
> +	}
> +out:
> +	mutex_unlock(&domain_acl_lock);
> +	return error;
> +}
> +
> +/**
> + * update_double_path_acl - Update "struct double_path_acl_record" list.
> + *
> + * @type:      Type of operation.
> + * @filename1: First filename.
> + * @filename2: Second filename.
> + * @domain:    Pointer to "struct domain_info".
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +static int update_double_path_acl(const u8 type, const char *filename1,
> +				  const char *filename2,
> +				  struct domain_info * const domain,
> +				  const bool is_delete)
> +{
> +	const struct path_info *saved_filename1;
> +	const struct path_info *saved_filename2;
> +	struct acl_info *ptr;
> +	struct double_path_acl_record *acl;
> +	int error = -ENOMEM;
> +	const u8 perm = 1 << type;
> +	if (!domain)
> +		return -EINVAL;
> +	if (!tmy_is_correct_path(filename1, 0, 0, 0, __func__) ||
> +	    !tmy_is_correct_path(filename2, 0, 0, 0, __func__))
> +		return -EINVAL;
> +	saved_filename1 = tmy_save_name(filename1);
> +	saved_filename2 = tmy_save_name(filename2);
> +	if (!saved_filename1 || !saved_filename2)
> +		return -ENOMEM;
> +	mutex_lock(&domain_acl_lock);
> +	if (is_delete)
> +		goto delete;
> +	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
> +		if (tmy_acl_type1(ptr) != TYPE_DOUBLE_PATH_ACL)
> +			continue;
> +		acl = container_of(ptr, struct double_path_acl_record, head);
> +		if (acl->filename1 != saved_filename1 ||
> +		    acl->filename2 != saved_filename2)
> +			continue;
> +		/* Special case. Clear all bits if marked as deleted. */
> +		if (ptr->type & ACL_DELETED)
> +			acl->perm = 0;
> +		acl->perm |= perm;
> +		error = tmy_add_domain_acl(NULL, ptr);
> +		goto out;
> +	}
> +	/* Not found. Append it to the tail. */
> +	acl = tmy_alloc_acl_element(TYPE_DOUBLE_PATH_ACL);
> +	if (!acl)
> +		goto out;
> +	acl->perm = perm;
> +	acl->filename1 = saved_filename1;
> +	acl->filename2 = saved_filename2;
> +	error = tmy_add_domain_acl(domain, &acl->head);
> +	goto out;
> +delete:
> +	error = -ENOENT;
> +	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
> +		if (tmy_acl_type2(ptr) != TYPE_DOUBLE_PATH_ACL)
> +			continue;
> +		acl = container_of(ptr, struct double_path_acl_record, head);
> +		if (acl->filename1 != saved_filename1 ||
> +		    acl->filename2 != saved_filename2)
> +			continue;
> +		acl->perm &= ~perm;
> +		error = tmy_del_domain_acl(acl->perm ? NULL : ptr);
> +		break;
> +	}
> +out:
> +	mutex_unlock(&domain_acl_lock);
> +	return error;
> +}
> +
> +/**
> + * check_single_path_acl - Check permission for single path operation.
> + *
> + * @domain:   Pointer to "struct domain_info".
> + * @type:     Type of operation.
> + * @filename: Filename to check.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +static int check_single_path_acl(struct domain_info *domain, const u8 type,
> +				 const struct path_info *filename)
> +{
> +	if (!tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE))
> +		return 0;
> +	return check_single_path_acl2(domain, filename, 1 << type, 1);
> +}
> +
> +/**
> + * check_double_path_acl - Check permission for double path operation.
> + *
> + * @domain:    Pointer to "struct domain_info".
> + * @type:      Type of operation.
> + * @filename1: First filename to check.
> + * @filename2: Second filename to check.
> + *
> + * Returns 0 on success, -EPERM otherwise.
> + */
> +static int check_double_path_acl(const struct domain_info *domain,
> +				 const u8 type,
> +				 const struct path_info *filename1,
> +				 const struct path_info *filename2)
> +{
> +	struct acl_info *ptr;
> +	const u8 perm = 1 << type;
> +	if (!tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE))
> +		return 0;
> +	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
> +		struct double_path_acl_record *acl;
> +		if (tmy_acl_type2(ptr) != TYPE_DOUBLE_PATH_ACL)
> +			continue;
> +		acl = container_of(ptr, struct double_path_acl_record, head);
> +		if (!(acl->perm & perm))
> +			continue;
> +		if (!tmy_path_matches_pattern(filename1,
> +					      acl->filename1))
> +			continue;
> +		if (!tmy_path_matches_pattern(filename2,
> +					      acl->filename2))
> +			continue;
> +		return 0;
> +	}
> +	return -EPERM;
> +}
> +
> +/**
> + * check_single_path_permission2 - Check permission for single path operation.
> + *
> + * @domain:    Pointer to "struct domain_info".
> + * @operation: Type of operation.
> + * @filename:  Filename to check.
> + * @mode:      Access control mode.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +static int check_single_path_permission2(struct domain_info * const domain,
> +					 u8 operation,
> +					 const struct path_info *filename,
> +					 const u8 mode)
> +{
> +	const char *msg;
> +	int error;
> +	const bool is_enforce = (mode == 3);
> +	if (!mode)
> +		return 0;
> +next:
> +	error = check_single_path_acl(domain, operation, filename);
> +	msg = tmy_sp2keyword(operation);
> +	if (!error)
> +		goto ok;
> +	if (tmy_verbose_mode(domain))
> +		printk(KERN_WARNING "TOMOYO-%s: Access '%s %s' denied for %s\n",
> +		       tmy_get_msg(is_enforce), msg, filename->name,
> +		       tmy_get_last_name(domain));
> +	if (mode == 1 && tmy_check_domain_quota(domain))
> +		update_single_path_acl(operation,
> +				       get_file_pattern(filename)->name,
> +				       domain, false);
> +	if (!is_enforce)
> +		error = 0;
> +ok:
> +	/*
> +	 * Since "allow_truncate" doesn't imply "allow_rewrite" permission,
> +	 * we need to check "allow_rewrite" permission if the filename is
> +	 * specified by "deny_rewrite" keyword.
> +	 */
> +	if (!error && operation == TMY_TYPE_TRUNCATE_ACL &&
> +	    is_no_rewrite_file(filename)) {
> +		operation = TMY_TYPE_REWRITE_ACL;
> +		goto next;
> +	}
> +	return error;
> +}
> +
> +/**
> + * tmy_check_file_perm - Check permission for sysctl()'s "read" and "write".
> + *
> + * @domain:    Pointer to "struct domain_info".
> + * @filename:  Filename to check.
> + * @perm:      Mode ("read" or "write" or "read/write").
> + * @operation: Always "sysctl".
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tmy_check_file_perm(struct domain_info *domain, const char *filename,
> +			const u8 perm, const char *operation)
> +{
> +	struct path_info name;
> +	const u8 mode = tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE);
> +	if (!mode)
> +		return 0;
> +	name.name = filename;
> +	tmy_fill_path_info(&name);
> +	return check_file_perm2(domain, &name, perm, operation, mode);
> +}
> +
> +/**
> + * tmy_check_exec_perm - Check permission for "execute".
> + *
> + * @domain:   Pointer to "struct domain_info".
> + * @filename: Check permission for "execute".
> + * @tmp:      Buffer for temporal use.
> + *
> + * Returns 0 on success, negativevalue otherwise.
> + */
> +int tmy_check_exec_perm(struct domain_info *domain,
> +			const struct path_info *filename,
> +			struct tmy_page_buffer *tmp)
> +{
> +	const u8 mode = tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE);
> +	if (!mode)
> +		return 0;
> +	return check_file_perm2(domain, filename, 1, "do_execve", mode);
> +}
> +
> +/**
> + * tmy_check_open_permission - Check permission for "read" and "write".
> + *
> + * @domain: Pointer to "struct domain_info".
> + * @dentry: Pointer to "struct dentry".
> + * @mnt:    Pointer to "struct vfsmount".
> + * @flag:   Flags for open().
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tmy_check_open_permission(struct domain_info *domain,
> +			      struct dentry *dentry, struct vfsmount *mnt,
> +			      const int flag)
> +{
> +	const u8 acc_mode = ACC_MODE(flag);
> +	int error = -ENOMEM;
> +	struct path_info *buf;
> +	const u8 mode = tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE);
> +	const bool is_enforce = (mode == 3);
> +	if (!mode || !mnt)
> +		return 0;
> +	if (acc_mode == 0)
> +		return 0;
> +	if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode))
> +		/*
> +		 * I don't check directories here because mkdir() and rmdir()
> +		 * don't call me.
> +		 */
> +		return 0;
> +	buf = tmy_get_path(dentry, mnt);
> +	if (!buf)
> +		goto out;
> +	error = 0;
> +	/*
> +	 * If the filename is specified by "deny_rewrite" keyword,
> +	 * we need to check "allow_rewrite" permission when the filename is not
> +	 * opened for append mode or the filename is truncated at open time.
> +	 */
> +	if ((acc_mode & MAY_WRITE) &&
> +	    ((flag & O_TRUNC) || !(flag & O_APPEND)) &&
> +	    (is_no_rewrite_file(buf))) {
> +		error = check_single_path_permission2(domain,
> +						      TMY_TYPE_REWRITE_ACL,
> +						      buf, mode);
> +	}
> +	if (!error)
> +		error = check_file_perm2(domain, buf, acc_mode, "open", mode);
> +	if (!error && (flag & O_TRUNC))
> +		error = check_single_path_permission2(domain,
> +						      TMY_TYPE_TRUNCATE_ACL,
> +						      buf, mode);
> +out:
> +	tmy_free(buf);
> +	if (!is_enforce)
> +		error = 0;
> +	return error;
> +}
> +
> +/**
> + * tmy_check_1path_perm - Check permission for "create", "unlink", "mkdir", "rmdir", "mkfifo", "mksock", "mkblock", "mkchar", "truncate" and "symlink".
> + *
> + * @domain:    Pointer to "struct domain_info".
> + * @operation: Type of operation.
> + * @dentry:    Pointer to "struct dentry".
> + * @mnt:       Pointer to "struct vfsmount".
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tmy_check_1path_perm(struct domain_info *domain, const u8 operation,
> +			 struct dentry *dentry, struct vfsmount *mnt)
> +{
> +	int error = -ENOMEM;
> +	struct path_info *buf;
> +	const u8 mode = tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE);
> +	const bool is_enforce = (mode == 3);
> +	if (!mode || !mnt)
> +		return 0;
> +	buf = tmy_get_path(dentry, mnt);
> +	if (!buf)
> +		goto out;
> +	switch (operation) {
> +	case TMY_TYPE_MKDIR_ACL:
> +	case TMY_TYPE_RMDIR_ACL:
> +		if (!buf->is_dir) {
> +			/* tmy_get_path() preserves space for appending "/." */
> +			strcat((char *) buf->name, "/");
> +			tmy_fill_path_info(buf);
> +		}
> +	}
> +	error = check_single_path_permission2(domain, operation, buf, mode);
> +out:
> +	tmy_free(buf);
> +	if (!is_enforce)
> +		error = 0;
> +	return error;
> +}
> +
> +/**
> + * tmy_check_rewrite_permission - Check permission for "rewrite".
> + *
> + * @domain: Pointer to "struct domain_info".
> + * @filp: Pointer to "struct file".
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tmy_check_rewrite_permission(struct domain_info *domain, struct file *filp)
> +{
> +	int error = -ENOMEM;
> +	const u8 mode = tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE);
> +	const bool is_enforce = (mode == 3);
> +	struct path_info *buf;
> +	if (!mode || !filp->f_path.mnt)
> +		return 0;
> +	buf = tmy_get_path(filp->f_path.dentry, filp->f_path.mnt);
> +	if (!buf)
> +		goto out;
> +	if (!is_no_rewrite_file(buf)) {
> +		error = 0;
> +		goto out;
> +	}
> +	error = check_single_path_permission2(domain, TMY_TYPE_REWRITE_ACL,
> +					      buf, mode);
> +out:
> +	tmy_free(buf);
> +	if (!is_enforce)
> +		error = 0;
> +	return error;
> +}
> +
> +/**
> + * tmy_check_2path_perm - Check permission for "rename" and "link".
> + *
> + * @domain:    Pointer to "struct domain_info".
> + * @operation: Type of operation.
> + * @dentry1:   Pointer to "struct dentry".
> + * @mnt1:      Pointer to "struct vfsmount".
> + * @dentry2:   Pointer to "struct dentry".
> + * @mnt2:      Pointer to "struct vfsmount".
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tmy_check_2path_perm(struct domain_info * const domain, const u8 operation,
> +			 struct dentry *dentry1, struct vfsmount *mnt1,
> +			 struct dentry *dentry2, struct vfsmount *mnt2)
> +{
> +	int error = -ENOMEM;
> +	struct path_info *buf1, *buf2;
> +	const u8 mode = tmy_check_flags(domain, TMY_TOMOYO_MAC_FOR_FILE);
> +	const bool is_enforce = (mode == 3);
> +	const char *msg;
> +	if (!mode || !mnt1 || !mnt2)
> +		return 0;
> +	buf1 = tmy_get_path(dentry1, mnt1);
> +	buf2 = tmy_get_path(dentry2, mnt2);
> +	if (!buf1 || !buf2)
> +		goto out;
> +	if (operation == TMY_TYPE_RENAME_ACL) {
> +		/* TYPE_LINK_ACL can't reach here for directory. */
> +		if (dentry1->d_inode && S_ISDIR(dentry1->d_inode->i_mode)) {
> +			/* tmy_get_path() preserves space for appending "/." */
> +			if (!buf1->is_dir) {
> +				strcat((char *) buf1->name, "/");
> +				tmy_fill_path_info(buf1);
> +			}
> +			if (!buf2->is_dir) {
> +				strcat((char *) buf2->name, "/");
> +				tmy_fill_path_info(buf2);
> +			}
> +		}
> +	}
> +	error = check_double_path_acl(domain, operation, buf1, buf2);
> +	msg = tmy_dp2keyword(operation);
> +	if (!error)
> +		goto out;
> +	if (tmy_verbose_mode(domain))
> +		printk(KERN_WARNING "TOMOYO-%s: Access '%s %s %s' "
> +		       "denied for %s\n", tmy_get_msg(is_enforce),
> +		       msg, buf1->name, buf2->name, tmy_get_last_name(domain));
> +	if (mode == 1 && tmy_check_domain_quota(domain))
> +		update_double_path_acl(operation,
> +				       get_file_pattern(buf1)->name,
> +				       get_file_pattern(buf2)->name,
> +				       domain, false);
> +out:
> +	tmy_free(buf1);
> +	tmy_free(buf2);
> +	if (!is_enforce)
> +		error = 0;
> +	return error;
> +}
> 
> --
